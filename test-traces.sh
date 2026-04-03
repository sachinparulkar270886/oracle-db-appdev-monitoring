#!/bin/bash

# Test script to generate sample traces for Tempo
# Uses a Python container to send OTLP traces to the collector

echo "🚀 Starting Oracle monitoring trace test..."
echo "📊 Using Docker container to send traces to OTel Collector"

# Create a temporary Python script
cat > /tmp/trace_test.py << 'EOF'
import time
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

# Configure tracing
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# Configure OTLP exporter to send to our collector
otlp_exporter = OTLPSpanExporter(
    endpoint="otel-collector:4317",
    insecure=True,
)

# Add the exporter to the tracer
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

def simulate_oracle_operations():
    """Simulate some Oracle database operations with traces"""
    print("🔄 Starting trace simulation...")

    # Main database operation span
    with tracer.start_as_current_span("oracle_database_operation") as main_span:
        main_span.set_attribute("db.system", "oracle")
        main_span.set_attribute("db.name", "freepdb1")
        main_span.set_attribute("service.name", "oracle-monitor-test")
        print("📊 Created main span")

        # Simulate connection
        with tracer.start_as_current_span("oracle_connect") as connect_span:
            connect_span.set_attribute("db.operation", "CONNECT")
            connect_span.set_attribute("net.transport", "tcp")
            connect_span.set_attribute("net.peer.name", "free23ai")
            connect_span.set_attribute("net.peer.port", 1521)
            time.sleep(0.1)  # Simulate connection time

        # Simulate query execution
        with tracer.start_as_current_span("oracle_query") as query_span:
            query_span.set_attribute("db.operation", "SELECT")
            query_span.set_attribute("db.statement", "SELECT COUNT(*) FROM v$session WHERE status='ACTIVE'")
            query_span.set_attribute("db.rows_affected", 5)
            time.sleep(0.2)  # Simulate query time

            # Nested span for result processing
            with tracer.start_as_current_span("process_results") as process_span:
                process_span.set_attribute("operation.type", "result_processing")
                process_span.set_attribute("records.processed", 5)
                time.sleep(0.05)

        # Simulate commit
        with tracer.start_as_current_span("oracle_commit") as commit_span:
            commit_span.set_attribute("db.operation", "COMMIT")
            time.sleep(0.02)

    print("✅ Trace batch completed")

def main():
    print("📤 Sending trace batches...")

    # Send multiple trace operations
    for i in range(3):
        print(f"Batch {i+1}/3...")
        simulate_oracle_operations()
        time.sleep(1)  # Wait between operations

    print("✅ Trace generation complete!")
    time.sleep(2)  # Give time for spans to be exported

if __name__ == "__main__":
    main()
EOF

# Run the Python script in a container
docker run --rm --network docker-compose_default -v /tmp/trace_test.py:/app/trace_test.py python:3.11-slim bash -c "
pip install opentelemetry-distro opentelemetry-exporter-otlp-proto-grpc && 
python /app/trace_test.py
"

echo "🔍 Check Tempo at http://localhost:3200 or Grafana Explore → Tempo datasource"
echo "💡 Look for traces with service.name = 'oracle-monitor-test'"