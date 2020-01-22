#!/bin/bash

JDK_VERSION=$1
TOMCAT_MAJOR_VERSION=$2
TOMCAT_VERSION=$3
MYSQL_VERSION=$4
USER_NAME=$5
MYSQL_ROOT_PASSWORD='P@55w0rd' 

sudo apt-get -y update
sudo apt-get -y upgrade

# Install Java
sudo apt-get install -y openjdk-$JDK_VERSION-jdk
sudo apt-get -y update --fix-missing

# Downloading Tomcat
wget https://www-eu.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR_VERSION/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -P /tmp
# Installing Tomcat
sudo tar xf /tmp/apache-tomcat-*.tar.gz -C /opt
sudo mv /opt/apache-tomcat-* /opt/tomcat
# For security purposes, Tomcat should not be run under the root user
# Changing User:Group for Tomcat
sudo chown -R $USER_NAME:$USER_NAME /opt/tomcat

# Enabling MySQL Silent Installation
export DEBIAN_FRONTEND=noninteractive

# Setting Root Password in DedConf
echo "mysql-server-$MYSQL_VERSION mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
echo "mysql-server-$MYSQL_VERSION mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
#sudo debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
#sudo debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

# Installing MySQL
sudo -E apt-get -qq install mysql-server-$MYSQL_VERSION > /dev/null # Install MySQL quietly

# Install Expect
sudo apt-get -qq install expect > /dev/null

# Build Expect script
tee ~/secure_our_mysql.sh > /dev/null << EOF
spawn $(which mysql_secure_installation)

expect "Enter password for user root:"
send "$MYSQL_ROOT_PASSWORD\r"

expect "Press y|Y for Yes, any other key for No:"
send "y\r"

expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:"
send "0\r"

expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
send "n\r"

expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
send "y\r"

EOF

# Run Expect script.
# This runs the "mysql_secure_installation" script which removes insecure defaults.
sudo expect ~/secure_our_mysql.sh

# Cleanup
rm -v ~/secure_our_mysql.sh # Remove the generated Expect script
sudo apt-get -qq purge expect > /dev/null # Uninstall Expect, commented out in case you need Expect

echo "MySQL setup completed. Insecure defaults are gone. Please remove this script manually when you are done with it (or at least remove the MySQL root password that you put inside it."

# Update and then close
sudo apt-get -y update
sudo apt-get -y upgrade

if netstat -tulpen | grep 8080
then
exit 0
fi
