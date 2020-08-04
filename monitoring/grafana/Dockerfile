FROM grafana/grafana:5.0.0

COPY datasource.yaml /etc/grafana/provisioning/datasources/
# copy provider
COPY dashboards.yaml /etc/grafana/provisioning/dashboards/
# copy dashboards
COPY dashboards /var/lib/grafana/dashboards
