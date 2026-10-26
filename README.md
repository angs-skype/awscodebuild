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
