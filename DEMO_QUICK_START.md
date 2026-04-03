# 🚀 DEMO QUICK START (5-Minute Setup)

## ✅ Pre-Demo Verification

All services are running:
- ✅ Grafana (http://localhost:3000)
- ✅ Prometheus (http://localhost:9090)
- ✅ Oracle Exporter (port 9161)
- ✅ OTel Collector (ports 4317/4318)
- ✅ Tempo (traces - http://localhost:3200)
- ✅ Loki (logs - http://localhost:3100)
- ✅ Oracle DB 1: free23ai
- ✅ Oracle DB 2: second23ai

---

## 🎯 DEMO STEPS (For Day-Of)

### **Step 0: Start Services (if not running)**
```bash
cd docker-compose
docker-compose up -d
```

### **Step 1: Generate Fresh Sample Traces (5 seconds)**
```bash
cd /Users/sachin/learning_setup/oracle-db-appdev-monitoring
./test-traces.sh
```

### **Step 2: Open Grafana (30 seconds)**
1. Open browser: http://localhost:3000
2. Login: admin / grafana
3. Wait for dashboard to load

### **Step 3: Point to Metrics Dashboard (1 minute)**
**Path**: Dashboards > Browse > Look for Oracle dashboard
**OR create quick dashboard:**
- Query: `up{job="exporter"}` → Shows database status
- Query: `oracle_sessions` → Shows active sessions
- Query: `rate(oracle_transactions[5m])` → Shows transaction rate

### **Step 4: Show Traces (2 minutes)**
1. **Explore** (compass icon) → Select **Tempo** datasource
2. **Paste Trace ID**: `438ffb6639903f15e91657b35ab149c7`
3. **Click Run** → Shows trace waterfall with spans

### **Step 5: Show Logs (1 minute)**
1. **Explore** → Select **Loki** datasource
2. **Query**: `{job="prometheus"}` → Shows all logs

---

## 💡 Quick Demo Script

**"Good morning! I want to show you our new Oracle Database monitoring solution."**

*[Show metrics dashboard]*
**"Real-time metrics from both Oracle databases. Active sessions, health status, performance metrics."**

*[Generate and show traces]*
**"When we need to debug a slow query, distributed tracing shows us exactly what happened - connection, query, processing, commit. Each step with timing and details."**

*[Show logs]*
**"All logs centralized here. Together with metrics and traces, we have complete visibility into what's happening."**

**"Best part? It's open-source. No licensing costs. And it works with any observability tool ecosystem."**

---

## 🔗 Key URLs for Demo

| Service | URL | Login |
|---------|-----|-------|
| **Grafana** | http://localhost:3000 | admin/grafana |
| **Prometheus** | http://localhost:9090 | - |
| **Tempo** | http://localhost:3200 | - |
| **Loki** | http://localhost:3100 | - |

---

## ⚠️ If Something Goes Wrong

```bash
# Restart all services
cd docker-compose
docker-compose restart

# Check service status
docker-compose ps

# View logs for a service
docker-compose logs grafana      # for Grafana
docker-compose logs tempo        # for Tempo
docker-compose logs loki         # for Loki

# Stop all and clean (if needed)
docker-compose down -v
docker-compose up -d
```

---

## 📝 Manager Talking Points (Prepared Answers)

**Q: "How is this different from Enterprise solutions?"**
- A: Open-source, scalable, no vendor lock-in, and we control our data.

**Q: "Can this handle 100+ databases?"**
- A: Yes, just add more exporters. Prometheus and Tempo scale horizontally.

**Q: "What about high availability?"**
- A: Can deploy to Kubernetes with redundancy. This is a single-node setup for demo.

**Q: "Cost?"**
- A: ~$0 for software. Cost is infrastructure (servers/cloud). Compare to enterprise APM: $10k+/month saved.

---

## ✨ Pro Tips for Smooth Demo

1. **Have Grafana pre-logged in** before demo starts
2. **Generate traces 2 minutes before** starting - gives time for data to be queryable
3. **Keep tabs open**: Grafana, this guide, and terminal hidden
4. **Practice the flow once** before actual demo
5. **Have your phone ready** to show mobile view if manager asks
6. **Keep it to 15 minutes max** - leave time for questions

---

**You're ready! Good luck! 🎉**
