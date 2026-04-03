# Oracle Database Monitoring Stack - Manager Demo Guide

## 📊 Demo Overview (15-20 minutes)

### **Key Points to Highlight:**
- Complete observability of Oracle databases (Metrics, Traces, Logs)
- Real-time performance monitoring
- Distributed tracing for application debugging
- Cost-effective open-source solution (Prometheus, Grafana, Tempo, Loki)

---

## 🎯 DEMO FLOW

### **PART 1: Architecture Overview (2 minutes)**

**Show this flow:**
```
Oracle DBs (free23ai, second23ai)
    ↓
Oracle Exporter (Metrics Collection)
    ↓
Prometheus (Metrics Storage)
    ↓
Grafana (Visualization)

+

OTel Collector (Data Collection)
    ↓
Tempo (Traces Storage)
    ↓
Grafana (Trace Visualization)

+

Loki (Log Aggregation)
```

**Key talking points:**
- "We're collecting metrics, traces, and logs from Oracle databases"
- "All data flows through open-source observability tools"
- "Everything visualized in Grafana dashboard"

---

### **PART 2: Live Demo - Metrics Dashboard (5 minutes)**

#### Step 1: Open Grafana
- **URL**: http://localhost:3000
- **Username**: admin
- **Password**: grafana

#### Step 2: Show Prometheus Datasource
1. Left sidebar → **Administration** → **Data sources**
2. Click **Prometheus** datasource
3. Show it's actively scraping metrics

#### Step 3: Create/Show Oracle Metrics Dashboard
1. Click **Dashboards** → Create new dashboard
2. Show these **Oracle Metrics**:
   - **Panel 1**: Active Sessions (from exporter)
     ```
     Query: oracle_sessions
     ```
   - **Panel 2**: Database Health (status checks)
     ```
     Query: up{job="exporter"}
     ```
   - **Panel 3**: System Metrics (CPU, Memory)

#### What to Say:
- "This dashboard shows real-time Oracle database performance"
- "Metrics are automatically collected every 15 seconds"
- "We can see session count, response times, and health status"

---

### **PART 3: Live Demo - Distributed Traces (5 minutes)**

#### Step 1: Generate Sample Traces
```bash
cd /Users/sachin/learning_setup/oracle-db-appdev-monitoring
./test-traces.sh
```

#### Step 2: View Traces in Grafana
1. **Explore** (compass icon) → Select **Tempo** datasource
2. **Enter Trace ID** in the Trace ID field:
   ```
   438ffb6639903f15e91657b35ab149c7
   ```
3. **Show the Trace Details:**
   - **Span waterfall** showing:
     - `oracle_database_operation` (parent span)
     - `oracle_connect` (child span)
     - `oracle_query` (child span)
     - `process_results` (nested span)
     - `oracle_commit` (child span)

#### What to Say:
- "This is distributed tracing - we can see exactly what's happening inside database transactions"
- "Each span shows duration and attributes (connection details, query info, etc.)"
- "Useful for debugging slow queries and performance issues"

---

### **PART 4: Live Demo - Log Aggregation (3 minutes)**

#### Step 1: Check Loki Health
```bash
curl http://localhost:3100/ready
```

#### Step 2: View Loki in Grafana
1. **Explore** → Select **Loki** datasource
2. Show log query:
   ```
   {job="prometheus"}
   ```

#### What to Say:
- "Loki allows us to centralize and search all application and system logs"
- "Can correlate logs with metrics and traces for complete observability"

---

### **PART 5: Key Features to Highlight (3 minutes)**

#### Feature 1: **Real-Time Alerting**
- Show Prometheus alerts configured in `prometheus/rules.yml`
- Example: Alert if Oracle DB is down or sessions exceed threshold

#### Feature 2: **Custom Dashboards**
- Grafana allows creation of unlimited custom dashboards
- Can slice/dice metrics by database, server, service

#### Feature 3: **Historical Analysis**
- Prometheus stores metrics for 15 days by default
- Can analyze trends over time

#### Feature 4: **Easy Integration**
- No code changes required
- Works with existing Oracle databases
- Uses standard exporters and collectors

---

## 💰 Business Value (To Mention)

| Benefit | Value |
|---------|-------|
| **Proactive Monitoring** | Catch issues before users report them |
| **Root Cause Analysis** | Distributed traces help debug issues faster |
| **Cost Optimization** | 100% open-source stack (no licensing fees) |
| **Scalability** | Handles multiple databases and microservices |
| **Team Enablement** | Self-service dashboards for developers |

---

## 🔧 Technical Details (If Manager Asks)

### Q: "How much infrastructure does this need?"
**Answer**: "Docker Compose on single machine. Can scale to Kubernetes if needed."

### Q: "What's the learning curve?"
**Answer**: "Grafana is intuitive. Team can create dashboards within a day."

### Q: "How much data are we storing?"
**Answer**: "Prometheus: 15 days of metrics. Tempo: 7 days of traces. Loki: 30 days of logs."

### Q: "Can we integrate with our on-call system?"
**Answer**: "Yes! Grafana alerts can send to PagerDuty, Slack, etc."

---

## 📱 Optional: Show on Multiple Databases

If you have two Oracle instances running:

```bash
# Show metrics from both databases
curl http://localhost:9090/api/v1/query?query=oracle_sessions
```

This demonstrates scalability.

---

## ✅ Pre-Demo Checklist

- [ ] All Docker containers running
- [ ] Grafana accessible (http://localhost:3000)
- [ ] Prometheus scraping metrics (http://localhost:9090)
- [ ] Tempo has sample traces (run test-traces.sh)
- [ ] Loki is running (http://localhost:3100/ready)
- [ ] Create a simple dashboard ahead of time with key metrics
- [ ] Have sample trace ID ready: `438ffb6639903f15e91657b35ab149c7`
- [ ] Test all URLs work before demo

---

## 🎬 Demo Script (Reading from this will help!)

**Opening:**
"Today I want to show you our new Oracle Database Monitoring solution. We've implemented a complete observability stack that gives us metrics, traces, and logs from all Oracle databases in real-time."

**Metrics Section:**
"First, let's look at the metrics dashboard. This shows us active sessions, database health, and performance metrics updated every 15 seconds. If any metric breaches a threshold, we can automatically send alerts."

**Traces Section:**
"Second, here's  distributed tracing. When we see a slow query alert, we can click through to see the exact trace showing what happened. Each span represents a step in the transaction - connection, query execution, result processing. This helps us debug issues much faster."

**Logs Section:**
"Third, all logs from our databases are centralized in Loki. We can search and filter by any field. Combined with metrics and traces, we have complete visibility."

**Closing:**
"The best part? This is all open-source, so there are no licensing costs. And it's cloud-agnostic - works on-premise, in AWS, GCP, Azure, or Kubernetes."

---

## 🎯 Questions Your Manager Might Ask

**Q1: "What about security? Is this exposed?"**
- A: "No, everything runs locally in Docker. Network access is controlled. For production, we'd add authentication and SSL."

**Q2: "What if we have hundreds of databases?"**
- A: "This architecture scales. We add more exporters, and Prometheus automatically discovers and scrapes them."

**Q3: "How do we troubleshoot issues?"**
- A: "We use the traces and logs together. For example, if a query is slow, we see the trace showing each step."

**Q4: "What's the operational overhead?"**
- A: "Minimal. Docker manages the containers. Grafana alerts notify the team automatically."

**Q5: "Can developers use this?"**
- A: "Yes! Self-service dashboards. They can query metrics and traces directly without waiting for ops team."

---

## 📊 After Demo: Next Steps to Propose

1. **Week 1**: Deploy to staging environment
2. **Week 2**: Set up alerting rules based on SLAs
3. **Week 3**: Train team on dashboards and trace debugging
4. **Week 4**: Production rollout with runbooks

---

**Good luck with your demo! 🚀**
