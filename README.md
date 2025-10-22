# Kubernetes Observability Stack (Grafana + Loki + Tempo + Mimir + Alloy)

Production-ready, kubeadm-compatible deployment for a cluster with **Cilium**, **MetalLB**, **Longhorn**, and namespace **`monitoring`**.

## Environment (assumed from your cluster)
- Kubernetes: v1.33.x (kubeadm)
- CNI: Cilium
- Pod CIDR: `10.0.0.0/16`
- Service CIDR: `10.96.0.0/12`
- LoadBalancer: MetalLB (`192.168.55.50–192.168.55.70`)
- Default StorageClass: `longhorn`
- Ingress Controller: ingress-nginx
- Namespace: `monitoring`

## What’s included
- `grafana/grafana.yaml` — Grafana values (pre-wired datasources: Loki, Tempo, Mimir)
- `grafana/install-grafana.sh` — Helm install (LoadBalancer IP: **192.168.55.58**)
- `grafana/uninstall-grafana.sh`
- `grafana/verify.sh`
- `alloy/install-alloy.sh` — Grafana Alloy (metrics/logs/traces → Mimir/Loki/Tempo)
- `alloy/uninstall-alloy.sh`
- `scripts/metalb-free-ips.sh` — Helper to list used/free MetalLB IPs
- `.gitignore`

> **Credentials:** Grafana admin user is `admin` with password `Str0ngPassw0rd!` (edit in `grafana/grafana.yaml` if desired).

---

## Quick start

```bash
git clone <your-repo-url>.git
cd k8s-observability
```

> Optional: confirm free LoadBalancer IPs (expects your pool is `192.168.55.50–192.168.55.70`):
```bash
bash scripts/metalb-free-ips.sh 192.168.55 50 70
```

### 1) Install Grafana
```bash
cd grafana
chmod +x install-grafana.sh verify.sh
./install-grafana.sh
./verify.sh
```

Access Grafana:
- URL: `http://192.168.55.58`
- Username: `admin`
- Password: `Str0ngPassw0rd!`

### 2) Install Grafana Alloy (telemetry collector)
```bash
cd ../alloy
chmod +x install-alloy.sh
./install-alloy.sh
```

### 3) Import dashboards (optional)
In Grafana → **Dashboards → Import**, you can use:
- Kubernetes Cluster Monitoring: `315`
- Node Exporter / System Metrics: `1860`
- Loki Logs Overview: `13639`
- Tempo Service Map: `17457`

---

## Uninstall

```bash
cd grafana && ./uninstall-grafana.sh
cd ../alloy && ./uninstall-alloy.sh
```

---

## Notes
- If `192.168.55.58` is not free, edit `grafana/grafana.yaml` → `service.loadBalancerIP` to another free IP from your pool.
- `storageClassName: longhorn` is set in `grafana/grafana.yaml` so PVCs bind to Longhorn.
- Datasource URLs expect in-cluster services:
  - Loki: `http://loki-gateway.loki.svc.cluster.local`
  - Tempo: `http://tempo-query-frontend.tempo.svc.cluster.local:3200`
  - Mimir: `http://mimir-gateway.mimir.svc.cluster.local/prometheus`

### Verify components
```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana
```

---

## Install Loki, Tempo, and Mimir

### Loki
```bash
cd loki
chmod +x install-loki.sh
./install-loki.sh
```
- Exposes `loki-gateway` (ClusterIP) used internally by Grafana.

### Tempo (distributed)
```bash
cd ../tempo
chmod +x install-tempo.sh
./install-tempo.sh
```
- Creates a compatibility `Service` named **`tempo-query-frontend`** on port **3200** to match the Grafana datasource URL.

### Mimir (distributed)
```bash
cd ../mimir
chmod +x install-mimir.sh
./install-mimir.sh
```
- Exposes **`mimir-gateway`** (ClusterIP) for Prometheus-compatible reads/writes.

---

## Uninstall components

```bash
cd loki && ./uninstall-loki.sh
cd ../tempo && ./uninstall-tempo.sh
cd ../mimir && ./uninstall-mimir.sh
```
