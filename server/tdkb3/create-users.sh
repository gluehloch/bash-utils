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

sudo apt install apache2

## Anleitung let´s encrypt bzw. https://certbot.eff.org/instructions?ws=apache&os=snap
sudo apt install snapd
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --apache

## TODO
## * Java, Maven und verschiedene Tools installieren
## * Apache: Alle Domains und Subdomains einrichten
## * Let´s encrypt einrichten
## * TOMCAT installieren
## ** 2 Instanzen? (1. Instanz) dev, test, prep und (2. Instanz) prod?
## * MariaDB installieren
## ** Verschiedene Umgebungen einricht DEV, TEST, PREP, PROD
## * Minecraft installieren
## * Domains umziehen / gluehloch => tippdiekistebier.de
