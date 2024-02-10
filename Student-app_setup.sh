#! /bin/bash


#git Clone

 sudo setsebool -P httpd_can_network_connect 1

cd /opt/student-app

git pull origin main

 mysql -uroot < /opt/student-app/dbscript/studentapp.sql

# managers app context.xml
cp /opt/student-app/tomcat/manager/context.xml /opt/appserver/webapps/manager/META-INF

# add user to the tomcat
cp /opt/student-app/tomcat/conf/tomcat-users.xml /opt/appserver/conf/

# load db driver
cp /opt/student-app/tomcat/lib/mysql-connector.jar /opt/appserver/lib/

# integrate tomcat with db
cp /opt/student-app/tomcat/conf/context.xml /opt/appserver/conf/

# restart tomcat service

sudo systemctl stop tomcat
sudo systemctl start tomcat


#Deploying student app

 cd /opt/student-app/

 echo 2 | sudo alternatives --config java

# mvn clean install

 mvn clean package

 echo ' 1' | sudo alternatives --config java

 cp /opt/student-app/target/*.war /opt/appserver/webapps/student.war

# Nginx static app deployment

cd /usr/share/nginx/html/

sudo rm -rf *

cd /opt/

cd static-project/iPortfolio/

sudo cp -R /opt/static-project/iPortfolio/* /usr/share/nginx/html/

# Reverse Proxy Configuration

sudo cp /opt/student-app/nginx/nginx.conf /etc/nginx/

sudo systemctl stop nginx
sudo systemctl start nginx
