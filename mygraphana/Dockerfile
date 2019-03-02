FROM ubuntu
LABEL maintainer="Dzmitry Belavusau"
#EXPOSE 3000
RUN apt-get update && \
    apt-get install -y curl gnupg gnupg2 gnupg1 && \
    echo "deb https://packages.grafana.com/oss/deb stable main" >> /etc/apt/sources.list.d/grafana.list && \
    curl https://packages.grafana.com/gpg.key | apt-key add -  && \
    apt-get update && \
    apt-get install -y adduser libfontconfig && \
    apt-get install -y grafana && \
    apt-get clean && \
    update-rc.d grafana-server defaults 95 10
COPY  influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY  serverinfo.json /usr/share/grafana/conf/provisioning/dashboards/
COPY  CPU_Memory.json /usr/share/grafana/conf/provisioning/dashboards/
COPY  dashboard.yaml /usr/share/grafana/conf/provisioning/dashboards/
ENTRYPOINT grafana-server --homepath="/usr/share/grafana"