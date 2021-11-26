# TOMCAT PARENT IMAGE
FROM registry.access.redhat.com/ubi8/openjdk-11 as tomcat

EXPOSE 8080

USER root

RUN curl https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.54.zip --output /tmp/apache-tomcat-9.0.54.zip && \

    microdnf install -y unzip && \
    unzip /tmp/apache-tomcat-9.0.54.zip -d /tmp/ && \
    mkdir /opt/tomcat && \
    mv /tmp/apache-tomcat-9.0.54/* /opt/tomcat/ && \

    chown -R jboss:0 /opt/tomcat && \
    chmod 770 /opt/tomcat && \
    chmod 770 /opt/tomcat/logs && \
    chmod 770 /opt/tomcat/webapps && \
    chmod 770 /opt/tomcat/conf && \
    chmod 770 /opt/tomcat/work && \

    chmod +x /opt/tomcat/bin/catalina.sh && \

    microdnf clean all && [ ! -d /var/cache/yum ] || rm -rf /var/cache/yum && \
    rm -r /tmp/apache-tomcat-9.0.54.zip && \
    rm -r /tmp/apache-tomcat-9.0.54

USER jboss

WORKDIR /opt/tomcat

ENTRYPOINT ["/opt/tomcat/bin/catalina.sh", "run"]

# BUILD RUN IMAGE
FROM tomcat

USER root

RUN rm -rf /opt/tomcat/webapps/*

COPY target/helloservlet.war /opt/tomcat/webapps/ROOT.war

