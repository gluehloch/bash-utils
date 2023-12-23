#!/bin/bash

JAVA_HOME='/c/development/devtools/java/jdk/jdk-17'
MAVEN_HOME='/c/development/devtools/java/maven/apache-maven-3.8.3'

export JAVA_HOME
export MAVEN_HOME

OLD_PATH=$PATH
export OLD_PATH

PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
export PATH

java --version
mvn --version
