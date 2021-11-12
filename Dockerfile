# BUILD RUN IMAGE
FROM quay.io/gmagnotta/tomcat:9.0.54

USER root

RUN rm -rf /opt/tomcat/webapps/*

COPY target/helloservlet.war /opt/tomcat/webapps/ROOT.war

