FROM ubuntu
LABEL maintainer="Dzmitry Belavusau"
RUN apt-get update && \
    apt-get install -y curl apache2 && \
    curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.1-amd64.deb && \
    dpkg -i filebeat-6.6.1-amd64.deb && \
    filebeat modules enable apache2
COPY filebeat.yml /etc/filebeat/
COPY entrypoint.sh /home/
RUN chmod +x /home/entrypoint.sh && \
    chmod 700 /etc/filebeat/filebeat.yml
CMD /home/entrypoint.sh
#ENTRYPOINT filebeat -c /etc/filebeat/filebeat.yml -e