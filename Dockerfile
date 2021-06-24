# Version JDK8

FROM centos:7
MAINTAINER Sricharan Koyalkar

RUN yum install -y software-properties-common install -y python3.8 add-yum-repository ppa:deadsnakes/ppa 
RUN yum install -y build-essential libssl-dev libffi-dev python3-dev yum install -y python3-venv
# Create users and groups
RUN mkdir environments
RUN cd environments
RUN python3 -m venv my_env
RUN ls my_env
RUN source my_env/bin/activate
RUN groupadd tomcat
RUN mkdir /opt/tomcat
RUN useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

# Download and install tomcat
RUN wget https://mirror.nodesdirect.com/apache/tomcat/tomcat-9/v9.0.48/bin/apache-tomcat-9.0.48.tar.gz
RUN tar -zxvf apache-tomcat-9.0.48.tar.gz -C /opt/tomcat --strip-components=1
RUN chgrp -R tomcat /opt/tomcat/conf
RUN chmod g+rwx /opt/tomcat/conf
RUN chmod g+r /opt/tomcat/conf/*
RUN chown -R tomcat /opt/tomcat/logs/ /opt/tomcat/temp/ /opt/tomcat/webapps/ /opt/tomcat/work/
RUN chgrp -R tomcat /opt/tomcat/bin
RUN chgrp -R tomcat /opt/tomcat/lib
RUN chmod g+rwx /opt/tomcat/bin
RUN chmod g+r /opt/tomcat/bin/*

RUN rm -rf /opt/tomcat/webapps/*
RUN cd /tmp && git clone https://github.com/csk17k/WebPanel.git
RUN cd /tmp/WebPanel && python3 WebPanel.py
RUN cp /tmp/WebPanel/target/login.war /opt/tomcat/webapps/ROOT.war
RUN chmod 777 /opt/tomcat/webapps/ROOT.war

VOLUME /opt/tomcat/webapps
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
#
