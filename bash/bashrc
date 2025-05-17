# awtools dev environment
export DEVTOOLS_HOME=/cygdrive/d/development/devtools

export JAVA_HOME="/cygdrive/d/development/devtools/java/jdk-11.0.2"
export ANT_HOME="$DEVTOOLS_HOME/ant/apache-ant-1.9.6"
export MAVEN_HOME="$DEVTOOLS_HOME/maven/apache-maven-3.5.4"
export GROOVY_HOME="$DEVTOOLS_HOME/groovy/groovy-2.4.14"
export GRADLE_HOME="$DEVTOOLS_HOME/gradle/gradle-5.2.1"
export XAMPP_HOME="$DEVTOOLS_HOME/xampp/xampp"
export MYSQL_HOME="$XAMP_HOME/mysql"
export PHP_HOME="$XAMPP_HOME/php"

export OLD_PATH=$PATH
export PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GROOVY_HOME/bin:$GRADLE_HOME/bin:$PHP_HOME:~/bin:$PATH:.

export TIPPDIEKISTEBIER=83.169.40.139
export TDKB=$TIPPDIEKISTEBIER

# Set START_SSH_AGEBT so it includes user's private bin if it exists
## Start SSH AGENT

if [ -e "${HOME}/bin/start_ssh_agent.sh" ] ; then
  source "${HOME}/bin/start_ssh_agent.sh"
fi

alias school='mysql -u school --password=school -D school -h 192.168.99.100 -P 3307'
alias bodata='mysql -u betoffice --password=betoffice -D betoffice -h 192.168.99.100 -P 3306'
alias dbload='mysql -u dbload --password=dbload -D dbload -h 192.168.99.100 -P 3310'
