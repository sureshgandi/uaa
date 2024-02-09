# Use an official Alpine Linux as a base image
FROM alpine:latest

# Install OpenJDK 17
RUN apk --no-cache add openjdk17

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

COPY ./build/extract/tomcat-9.0.85/apache-tomcat-9.0.85 $CATALINA_HOME

# Install Tomcat
#RUN apk --no-cache add tomcat-native && \
#    wget -O /tmp/apache-tomcat.tar.gz http://apache.mirrors.pair.com/tomcat/tomcat-9/v9.0.60/bin/apache-tomcat-9.0.60.tar.gz && \
#    tar xfz /tmp/apache-tomcat.tar.gz -C /usr/local && \
#    ln -s /usr/local/apache-tomcat-9.0.60 $CATALINA_HOME && \
#    rm -f /tmp/apache-tomcat.tar.gz

RUN mkdir /workspace

COPY  ./uaa/build/libs/cloudfoundry-identity-uaa-*.war /workspace/

RUN unzip -q /workspace/cloudfoundry-identity-uaa-*.war -d /usr/local/tomcat/webapps/uaa


# Remove ROOT in webapps
#RUN rm -rf /usr/local/tomcat/webapps/ROOT


# Symlink the temporary workspace to the Tomcat webapps directory
#RUN ln -s /workspace/cloudfoundry-identity-uaa-*.war /usr/local/tomcat/webapps/uaa.war


# Expose the default Tomcat port
EXPOSE 8080 8443

# Start Tomcat
CMD ["catalina.sh", "run"]
