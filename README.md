test14

docker compose up -d


Access the Web Interfaces

• Grafana: http://<YOUR_IP>:3000 (Default login: user admin / password admin)
• Prometheus: http://<YOUR_IP>:9090


Connect Grafana to Prometheus

1. Log into Grafana, navigate to Connections > Data Sources > Add data source, and pick Prometheus.
2. For the URL, use http://prometheus:9090 (using the Docker container name).
3. Scroll to the bottom and click Save & test.
4. Go to Dashboards > New > Import, paste ID 1860, select your Prometheus data source, and click Import to view your metrics.

===========================================================
Codespace special:


The most reliable way to make containers talk to each other in a Codespace is to bypass the bridge network entirely and use the host network mode. This forces the containers to share the Codespace's local network loopback (localhost).
Update your docker-compose.yml file to look like this:
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    network_mode: "host" # <-- Use host networking

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    network_mode: "host" # <-- Use host networking

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    volumes:
      - grafana-data:/var/lib/grafana
    network_mode: "host" # <-- Use host networking

volumes:
  prometheus-data:
  grafana-data:

Update prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['127.0.0.1:9100'] # <-- Change this to localhost / 127.0.0.1


docker compose down
docker compose up -d
