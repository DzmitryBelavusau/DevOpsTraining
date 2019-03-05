FROM tomcat:9-jre8
LABEL maintainer="Dzmitry Belavusau"
ARG WARPATH=http://10.70.5.201:8081/nexus/content/repositories/snapshots/test/1.0.29/task7b.war
EXPOSE 8080
ADD ${WARPATH} /usr/local/tomcat/webapps/task7b.war
CMD ["catalina.sh", "run"]