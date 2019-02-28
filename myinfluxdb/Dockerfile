FROM influxdb
LABEL maintainer="Dzmitry Belavusau"
EXPOSE 8083
EXPOSE 8086
EXPOSE 25826
COPY influxdb.conf /etc/influxdb/influxdb.conf
COPY types.db /usr/share/collectd/types.db
ENTRYPOINT influxd -config /etc/influxdb/influxdb.conf