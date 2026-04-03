#!/bin/bash

# Pre-Demo Health Check Script
# Run this 5 minutes before your demo to verify everything is working

set -e

echo "🔍 Oracle Monitoring Stack - Pre-Demo Health Check"
echo "=================================================="
echo ""

# Change to docker-compose directory
cd "$(dirname "$0")/docker-compose" || exit 1

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_service() {
    local service_name=$1
    local url=$2
    local timeout=${3:-5}
    
    if docker-compose ps | grep -q "$service_name.*Up"; then
        echo -e "${GREEN}✓${NC} $service_name is running"
        
        if [ -n "$url" ]; then
            if curl -s --connect-timeout "$timeout" "$url" > /dev/null 2>&1; then
                echo -e "${GREEN}  ✓ Responding to requests${NC}"
            else
                echo -e "${YELLOW}  ⚠ Not responding yet (may still be initializing)${NC}"
            fi
        fi
    else
        echo -e "${RED}✗${NC} $service_name is NOT running"
        return 1
    fi
}

# 1. Check Docker daemon
echo "1️⃣  Checking Docker..."
if docker ps > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Docker daemon is running"
else
    echo -e "${RED}✗${NC} Docker daemon is NOT running"
    exit 1
fi
echo ""

# 2. Check all services
echo "2️⃣  Checking Services..."
check_service "grafana" "http://localhost:3000/api/health" || true
check_service "prometheus" "http://localhost:9090/-/healthy" || true
check_service "tempo" "http://localhost:3200/ready" || true
check_service "loki" "http://localhost:3100/ready" || true
check_service "free23ai" "" || true
check_service "second23ai" "" || true
check_service "exporter" "" || true
check_service "otel-collector" "" || true
echo ""

# 3. Check Grafana login
echo "3️⃣  Checking Grafana Authentication..."
if curl -s -u admin:grafana http://localhost:3000/api/user > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Grafana authentication working (admin/grafana)"
else
    echo -e "${YELLOW}⚠${NC} Grafana not responding yet${NC}"
fi
echo ""

# 4. Check Prometheus metrics
echo "4️⃣  Checking Prometheus Metrics..."
METRIC_COUNT=$(curl -s 'http://localhost:9090/api/v1/query?query=up' | grep -o '"__value__"' | wc -l || echo "0")
if [ "$METRIC_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Prometheus collecting metrics ($METRIC_COUNT values found)"
else
    echo -e "${YELLOW}⚠${NC} Prometheus metrics not yet available${NC}"
fi
echo ""

# 5. Check Tempo traces
echo "5️⃣  Checking Tempo Traces..."
TRACE_COUNT=$(curl -s 'http://localhost:3200/api/traces?service.name=oracle-monitor-test' | grep -o '"traceID"' | wc -l || echo "0")
if [ "$TRACE_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Tempo has traces ($TRACE_COUNT traces found)"
else
    echo -e "${YELLOW}⚠${NC} No traces in Tempo yet (run ./test-traces.sh)${NC}"
fi
echo ""

# 6. Check Loki logs
echo "6️⃣  Checking Loki Logs..."
LOKI_RESPONSE=$(curl -s 'http://localhost:3100/ready' && echo "ready" || echo "not-ready")
if [ "$LOKI_RESPONSE" = "ready" ]; then
    echo -e "${GREEN}✓${NC} Loki is ready for queries"
else
    echo -e "${YELLOW}⚠${NC} Loki is initializing${NC}"
fi
echo ""

# 7. Summary
echo "=================================================="
echo "📋 Summary:"
echo "   Grafana:   http://localhost:3000 (admin/grafana)"
echo "   Prometheus: http://localhost:9090"
echo "   Tempo:     http://localhost:3200"
echo "   Loki:      http://localhost:3100"
echo ""

echo -e "${GREEN}✅ Pre-demo health check complete!${NC}"
echo ""
echo "🚀 If any service shows ⚠, wait 1-2 minutes and run this script again."
echo "📊 If you need fresh traces, run: ./test-traces.sh"
echo ""
