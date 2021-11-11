# BUILD IMAGE
FROM registry.access.redhat.com/ubi8/openjdk-11 as builder

USER root

COPY . /tmp/src

WORKDIR /tmp/src

RUN mvn clean package

# RUN IMAGE
FROM quay.io/gmagnotta/tomcat:9.0.54

USER root

RUN rm -rf /opt/tomcat/webapps/*

COPY --from=builder /tmp/src/target/helloservlet.war /opt/tomcat/webapps/ROOT.war

