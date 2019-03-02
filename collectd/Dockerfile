FROM ubuntu
LABEL maintainer="Dzmitry Belavusau"
#EXPOSE 25826
RUN apt-get update && \
    apt-get install -y collectd
COPY collectd.conf /etc/collectd/
ENTRYPOINT [ "collectd", "-f" ]