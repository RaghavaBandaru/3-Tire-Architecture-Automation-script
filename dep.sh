#! /bin/bash


sudo setsebool -P httpd_can_network_connect 1

# git pull origin main
mysql -uroot < ./dbscript/studentapp.sql

# managers app context.xml
sudo su devops -c "cp ./tomcat/manager/context.xml /opt/appserver/webapps/manager/META-INF"

# add user to the tomcat
sudo su devops -c "cp ./tomcat/conf/tomcat-users.xml /opt/appserver/conf/"

# load db driver
sudo su devops -c "cp ./tomcat/lib/mysql-connector.jar /opt/appserver/lib/"

# integrate tomcat with db
sudo su devops -c "cp ./tomcat/conf/context.xml /opt/appserver/conf/"

# restart tomcat service

sudo systemctl stop tomcat
sleep 30
sudo systemctl start tomcat
