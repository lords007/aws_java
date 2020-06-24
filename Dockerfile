FROM tomcat:8.0
RUN rm -rf /usr/local/tomcat/webapps/*
RUN mkdir -p /usr/local/tomcat/newrelic
ADD newrelic/newrelic.jar /usr/local/tomcat/newrelic/newrelic.jar
ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/local/tomcat/newrelic/newrelic.jar"

ADD ./newrelic/newrelic.yml /usr/local/tomcat/newrelic/newrelic.yml
ENV NEW_RELIC_APP_NAME="soumya-app"
ENV JAVA_OPTS="$JAVA_OPTS -Dnewrelic.config.app_name='soumya-app'"
ENV NEW_RELIC_LICENSE_KEY="86f3bcef4c5555724547882388cf520f3ea5NRAL"
ENV JAVA_OPTS=-Dnewrelic.config.log_file_name=STDOUT
COPY target/Spring4MVCAngularJSExample.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh","run"]
