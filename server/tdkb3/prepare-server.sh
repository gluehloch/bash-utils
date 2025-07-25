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

sudo groupadd webapp

# sudo passwd USERNAME
# Beispiel ssh key generator plus copy to remote server
ssh-keygen -t ed25519 -C "<email@address>"
ssh-copy-id -i tdkb3-gluehloch.pub gluehloch@gluehloch.de

sudo usermod -a -G bodev winkler
sudo usermod -a -G botest winkler
sudo usermod -a -G boprep winkler
sudo usermod -a -G boprod winkler

# Alle neuen/geänderten Dateien erhalten das Gruppenattribut "bodev"
sudo chgrp bodev /var/www/tippdiekistebier-dev
sudo chmod g+s /var/www/tippdiekistebier-dev

sudo chgrp botest /var/www/tippdiekistebier-test
sudo chmod g+s /var/www/tippdiekistebier-test

sudo chgrp boprep /var/www/tippdiekistebier-prep
sudo chmod g+s /var/www/tippdiekistebier-prep

sudo chgrp boprod /var/www/tippdiekistebier
sudo chmod g+s /var/www/tippdiekistebier

sudo chgrp webapp /opt/devtools/java/tomcat/<tomcat-version>/webapps
sudo chmod g+s /opt/devtools/java/tomcat/<tomcat-version>/webapps

mkdir ~/tmp
mkdir ~/dev
mkdir ~/dev/projects
mkdir ~/dev/projects/pom
mkdir ~/dev/projects/homepage
mkdir ~/dev/projects/tools
mkdir ~/dev/projects/betoffice
mkdir ~/dev/projects/betoffice/web
mkdir ~/dev/projects/betoffice/core
mkdir ~/dev/projects/betoffice/pom
mkdir ~/dev/projects/lab
mkdir ~/dev/tmp

sudo mkdir /opt/conf
sudo mkdir /opt/devtools
sudo mkdir /opt/devtools/java
sudo mkdir /opt/devtools/java/jdk
sudo mkdir /opt/devtools/java/maven
sudo mkdir /opt/devtools/java/tomcat
sudo mkdir /opt/devtools/node

cd /opt/devtools
sudo wget https://aka.ms/download-jdk/microsoft-jdk-21.0.7-linux-x64.tar.gz
sudo wget https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_linux-x64_bin.tar.gz
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.10/binaries/apache-maven-3.9.10-bin.tar.gz
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.43/bin/apache-tomcat-10.1.43.tar.gz

sudo gunzip microsoft-jdk-21.0.7-linux-x64.tar.gz -d /opt/devtools/java/jdk
sudo tar -xvf microsoft-jdk-21.0.7-linux-x64.tar -C /opt/devtools/java/jdk
sudo gunzip openjdk-24.0.1_linux-x64_bin.tar.gz -d /opt/devtools/java/jdk
sudo tar -xvf openjdk-24.0.1_linux-x64_bin.tar -C /opt/devtools/java/jdk
sudo gunzip apache-maven-3.9.10-bin.tar.gz -d /opt/devtools/java/maven
sudo tar -xvf apache-maven-3.9.10-bin.tar -C /opt/devtools/java/maven
sudo gunzip apache-tomcat-10.1.43.tar.gz -d /opt/devtools/java/tomcat
sudo tar -xvf apache-tomcat-10.1.43.tar -C /opt/devtools/java/tomcat

sudo wget https://nodejs.org/dist/v22.16.0/node-v22.16.0-linux-x64.tar.xz
sudo wget https://nodejs.org/dist/v20.19.2/node-v20.19.2-linux-x64.tar.xz
sudo tar -xf node-v22.16.0-linux-x64.tar.xz -C /opt/devtools/node
sudo tar -xf node-v20.19.2-linux-x64.tar.xz -C /opt/devtools/node

sudo chown -R devtools:devtools /opt/devtools

### bash erweiternh
### AWI
if [ -f ~/.bash_awi ]; then
    . ~/.bash_awi
fi
export PATH=$PATH:/home/winkler/.local/bin
eval "$(oh-my-posh init bash)"

cd ~/dev/projects/homepage
git clone git@github.com:gluehloch/andre-winkler-it.git
cd ~/dev/projects/pom
git clone git@github.com:gluehloch/master-pom.git
cd ~/dev/projects/betoffice/pom
git clone git@github.com:gluehloch/bo-pom.git
cd ~/dev/projects/betoffice/core
git clone git@github.com:gluehloch/bo-testutils.git
git clone git@github.com:gluehloch/bo-storage.git
git clone git@github.com:gluehloch/bo-openligadb.git
cd ~/dev/projects/betoffice/web
git clone git@github.com:gluehloch/bo-rest.git
git clone git@github.com:gluehloch/bo-frontend.git
cd ~/dev/projects/lab
git clone git@github.com:gluehloch/registrationservice.git register


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
sudo mkdir /var/www/andre-winkler
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

sudo chown -R winker:winkler /var/www/andre-winkler
sudo chown -R gluehloch:gluehloch /var/www/cookie.gluehloch
sudo chown -R gluehloch:gluehloch /var/www/gluehloch
sudo chown -R gluehloch:gluehloch /var/www/html
sudo chown -R gluehloch:gluehloch /var/www/lab.gluehloch
sudo chown -R gluehloch:gluehloch /var/www/maven.gluehloch
sudo chown -R gluehloch:gluehloch /var/www/maven-snap.gluehloch
sudo chown -R gluehloch:gluehloch /var/www/projects.gluehloch

sudo chown -R boprod:boprod /var/www/tippdiekistebier
sudo chown -R boprep:boprep /var/www/tippdiekistebier-prep
sudo chown -R botest:botest /var/www/tippdiekistebier-test
sudo chown -R bodev:bodev /var/www/tippdiekistebier-dev

### Apachae enable site 
# To enable an Apache2 site using a2ensite, navigate to the sites-available directory,
# and run the command a2ensite <site_name>, where <site_name> is the name of your site's
# configuration file without the .conf extension.
# Then, reload Apache using sudo service apache2 reload. 
cd /etc/apache2/sites-available

sudo a2ensite andre-winkler.conf
sudo a2ensite cookie.gluehloch.conf
sudo a2ensite gluehloch.conf
sudo a2ensite lab.gluehloch.conf
sudo a2ensite maven.gluehloch.conf
sudo a2ensite maven-snap.gluehloch.conf
sudo a2ensite projects.gluehloch.conf
sudo a2ensite tippdiekistebier.conf
sudo a2ensite dev.tippdiekistebier.conf
sudo a2ensite prep.tippdiekistebier.conf
sudo a2ensite test.tippdiekistebier.conf

sudo systemctl reload apache2

## * Apache: Alle Domains und Subdomains einrichten
## * Let´s encrypt einrichten
## * TOMCAT installieren
## ** 2 Instanzen? (1. Instanz) dev, test, prep und (2. Instanz) prod?
## * MariaDB installieren
## ** Verschiedene Umgebungen einricht DEV, TEST, PREP, PROD
## * Minecraft installieren
## * Domains umziehen / gluehloch => tippdiekistebier.de

### gluehloch.schonnebeck | 192.168.0.121
# C:\windows\System32\drivers\etc\hosts
192.168.0.121 andre-winkler.schonnebeck

192.168.0.121 gluehloch.schonnebeck
192.168.0.121 cookie.gluehloch.schonnebeck
192.168.0.121 lab.gluehloch.schonnebeck
192.168.0.121 maven.gluehloch.schonnebeck
192.168.0.121 maven-snap.gluehloch.schonnebeck
192.168.0.121 projects.gluehloch.schonnebeck

192.168.0.121 tippdiekistebier.schonnebeck
192.168.0.121 tippdiekistebier.schonnebeck
192.168.0.121 dev.tippdiekistebier.schonnebeck
192.168.0.121 test.tippdiekistebier.schonnebeck
192.168.0.121 prep.tippdiekistebier.schonnebeck
192.168.0.121 tippdiekistebier.schonnebeck

### MariaDB Installation
sudo apt install mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb
sudo mysql_secure_installation

### Tomcat Installation / Software Package ist bereits ausgepackt
cd /opt/devtools/java/tomcat
sudo ln -s /opt/devtools/java/tomcat/apache-tomcat-10.1.41 tomcat-prod
sudo chown devtools:devtools tomcat-prod

### Tomcat als SYstemd Service
# /etc/systemd/system
sudo cp server/tdkb3/tomcat/tomcat.service /etc/systemd/system/tomcat.service
sudo systemctl daemon-reload
sudo systemctl enable tomcat.service
# TODO Failed to enable unit: Unit file tomcat.service does not exist


##
## TDKB3 Läuft in der Timezone UTC
## clone schonnebeck in der Timezone Europe/Berlin
## MariaDB läuft in der SYSTEM Timezone
sudo timedatectl set-timezone UTC

### Bash Update
# Siehe auch https://ohmyposh.dev/docs/installation/linux
sudo apt install net-tools
sudo apt install curl
curl -s https://ohmyposh.dev/install.sh | bash -s

oh-my-posh font install
oh-my-posh font install meslo

### user-profilke spezifische Installationen
~/.local/bin

### .bashrc extension
### AWI Extension
export PATH=$PATH:/home/winkler/.local/bin
eval "$(oh-my-posh init bash)"

sudo mkdir /opt/conf
sudo mkdir /opt/conf/betoffice
sudo mkdir /opt/conf/register

sudo chown -R tomcat:tomcat /opt/conf
sudo adduser winkler tomcat

### Database Backup
# mariadb user einloggen 
mkdir ~/.local
mkdir ~/.local/bin
mkdir ~/backup

* Daily database backup

  Editieren der crontab Einträge für einen User:

+------------------------------------------------------------------------------+
crontab -e
+------------------------------------------------------------------------------+

  Das Skript möchte ich einmal täglich um 20:20 Uhr ausführen lassen. Dazu
  eignet sich ein CRON Job am besten. Die Steuerung erfolgt über die
  folgenden Befehle:
  
  * Auflisten aller crontab Einträge für einen User:

+------------------------------------------------------------------------------+
crontab -l
+------------------------------------------------------------------------------+

  * Für mein Backup Skript habe ich die folgende Zeiteinteilung gewählt:

+------------------------------------------------------------------------------+
# m h  dom mon dow   command
20 20 * * * /home/betoffice/bin/backup_betoffice.sh
+------------------------------------------------------------------------------+
  
  []

  Dabei haben die Spalten in der crontab die folgende Bedeutung:
 
  * 1. Spalte - Minute
    0-59 (mehrere Minuten-Angaben mit Komma, z.B. 0,30 für xx:00 und xx:30 Uhr) 
    * für alle Minuten 
    */5 für alle 5 Minuten (also xx:00, xx:05, xx:10 Uhr, usw.) 

  * 2. Spalte - Stunde
    0-23 (mehrere Stunden-Angaben mit Komma, z.B. 10,13,17 für 10:xx, 13:xx und 17:xx Uhr) 
    * für alle Stunden 
    */4 für alle 4 Stunden (also 00:xx, 04:xx, 08:xx, 12:xx, 16:xx und 20:xx Uhr) 

  * 3. Spalte - Tag im Monat
    1-31 
    * für jeden Tag 

  * 4. Spalte - Monat
    1-12 
    * für jeden Monat 

  * 5. Spalte - Wochentag
    0-7 (0 und 7 stehen für Sonntag, 1 für Montag, usw.) 
    * für jeden Wochentag 

  []
  
  * Damit die Backup-Dateien auf einen anderen Rechner gespiegel werden,
    kann man den folgenden Befehl verwenden:
