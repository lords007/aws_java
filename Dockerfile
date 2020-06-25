FROM tomcat:8.0.21-jre7 

MAINTAINER Soumya 

RUN rm -rf /usr/local/tomcat/webapps/*

ENV JAVA_OPTS -Xms256m -Xmx1024m -XX:MaxPermSize=256m
ENV NEWRELIC_KEY 86f3bcef4c5555724547882388cf520f3ea5NRAL
ENV NEWRELIC_APP_NAME soumya-app

RUN         apt-get update && apt-get install -y \ 
		unzip \
		wget

RUN	   ln -sf /usr/local/tomcat/webapps /webapps && \
		rm -rf /webapps/examples && \
		rm -rf /webapps/docs && \
		wget -q "http://download.newrelic.com/newrelic/java-agent/newrelic-agent/3.15.0/newrelic-java-3.15.0.zip" -O /tmp/newrelic.zip && \
		unzip /tmp/newrelic.zip -d /usr/local/tomcat/ && \
		rm /tmp/newrelic.zip && \
		cd /usr/local/tomcat/newrelic && \
		java -jar newrelic.jar install

RUN 	cp /usr/local/tomcat/newrelic/newrelic.yml /usr/local/tomcat/newrelic/newrelic.yml.original && \
	cat /usr/local/tomcat/newrelic/newrelic.yml.original | sed -e "s/'<\%= license_key \%>'/\'${NEWRELIC_KEY}\'/g" | sed -e "s/app_name:\ My\ Application/app_name:\ ${NEWRELIC_APP_NAME}/g" > /usr/local/tomcat/newrelic/newrelic.yml

COPY target/Spring4MVCAngularJSExample.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh","run"]
