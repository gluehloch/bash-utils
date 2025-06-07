#/bin/bash
sudo useradd -m -s /bin/bash boprod
sudo useradd -m -s /bin/bash boprep
sudo useradd -m -s /bin/bash botest
sudo useradd -m -s /bin/bash bodev

sudo useradd -m -s /bin/bash devtools
sudo useradd -m -s /bin/bash gluehloch
sudo useradd -m -s /bin/bash mariadb
sudo useradd -m -s /bin/bash minecraft
sudo useradd -m -s /bin/bash tomcat

mkdir ~/tmp
mkdir ~/dev
mkdir ~/projects
mkdir ~/projects/tools
mkdir ~/dev/tmp

sudo mkdir /opt/conf
sudo mkdir /opt/devtools
sudo mkdir /opt/devtools/java
sudo mkdir /opt/devtools/java/jdk
sudo mkdir /opt/devtools/java/maven
sudo mkdir /opt/devtools/java/tomcat
sudo mkdir /opt/devtools/node

cd /opt/devtools
sudo wget https://aka.ms/download-jdk/microsoft-jdk-21.0.7-linux-aarch64.tar.gz
sudo wget https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_linux-x64_bin.tar.gz
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.10/binaries/apache-maven-3.9.10-bin.tar.gz
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.41/bin/apache-tomcat-10.1.41.tar.gz

sudo gunzip microsoft-jdk-21.0.7-linux-aarch64.tar.gz -d /opt/devtools/java/jdk
sudo tar -xvf microsoft-jdk-21.0.7-linux-aarch64.tar -C /opt/devtools/java/jdk
sudo gunzip openjdk-24.0.1_linux-x64_bin.tar.gz -d /opt/devtools/java/jdk
sudo tar -xvf openjdk-24.0.1_linux-x64_bin.tar -C /opt/devtools/java/jdk
sudo gunzip apache-maven-3.9.10-bin.tar.gz -d /opt/devtools/java/maven
sudo tar -xvf apache-maven-3.9.10-bin.tar -C /opt/devtools/java/maven
sudo gunzip apache-tomcat-10.1.41.tar.gz -d /opt/devtools/java/tomcat
sudo tar -xvf apache-tomcat-10.1.41.tar -C /opt/devtools/java/tomcat

sudo wget https://nodejs.org/dist/v22.16.0/node-v22.16.0-linux-x64.tar.xz
sudo wget https://nodejs.org/dist/v20.19.2/node-v20.19.2-linux-x64.tar.xz
tar -xf node-v22.16.0-linux-x64.tar.xz -C /opt/devtools/node
tar -xf node-v20.19.2-linux-x64.tar.xz -C /opt/devtools/node

sudo chown -R devtools:devtools /opt/devtools

sudo apt install apache2

## Anleitung let´s encrypt bzw. https://certbot.eff.org/instructions?ws=apache&os=snap
sudo apt install snapd
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --apache

## TODO
## * Java, Maven und verschiedene Tools

## Apache: Verzeichnisse anlegen
sudo mkdir /var/www
sudo mkdir /var/www/cookie.gluehloch
sudo mkdir /var/www/gluehloch
sudo mkdir /var/www/html
sudo mkdir /var/www/lab.gluehloch
sudo mkdir /var/www/maven.gluehloch
sudo mkdir /var/www/maven-snap.gluehloch
sudo mkdir /var/www/projects.gluehloch
sudo mkdir /var/www/tippdiekistebier
sudo mkdir /var/www/tippdiekistebier-dev
sudo mkdir /var/www/tippdiekistebier-prep
sudo mkdir /var/www/tippdiekistebier-test


## * Apache: Alle Domains und Subdomains einrichten
## * Let´s encrypt einrichten
## * TOMCAT installieren
## ** 2 Instanzen? (1. Instanz) dev, test, prep und (2. Instanz) prod?
## * MariaDB installieren
## ** Verschiedene Umgebungen einricht DEV, TEST, PREP, PROD
## * Minecraft installieren
## * Domains umziehen / gluehloch => tippdiekistebier.de
