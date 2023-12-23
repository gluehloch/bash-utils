#!/bin/bash
#
# Creates a build environment.
#
# Andre Winkler
# v1.0
#

INSTALLDIR=$(pwd)
echo "Install directory $INSTALLDIR"

if [ ! -e "$INSTALLDIR/download" ]; then
    mkdir "$INSTALLDIR/download"
fi

if [ ! -e "$INSTALLDIR/devtools" ]; then
    mkdir "$INSTALLDIR/devtools"
fi

if [ ! -e "$INSTALLDIR/devtools/java" ]; then
    mkdir "$INSTALLDIR/devtools/java"
fi

DOWNLOAD_OPENJDK_URL="https://download.java.net/java/GA/jdk11/9/GPL"
JDK11_TAR="openjdk-11.0.2_linux-x64_bin.tar.gz"
JDK11_0_2="jdk-11.0.2"

DOWNLOAD_MAVEN_URL="https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/"
MAVEN36_TAR="apache-maven-3.6.0-bin.tar.gz"


if [ -e "$INSTALLDIR/download/$JDK11_TAR" ]; then
    echo "JDK 11 is already downloaded ..."
else
    wget -P "$INSTALLDIR/download" "$DOWNLOAD_OPENJDK_URL/$JDK11_TAR"
    wget -P "$INSTALLDIR/download" "$DOWNLOAD_MAVEN_URL/$MAVEN36_TAR"
fi

if [ -e "$INSTALLDIR/devtools/java/$JDK11_0_2" ]; then
    echo " ... and installed."
else
    tar -C "$INSTALLDIR/devtools/java" -xvf "$INSTALLDIR/download/$JDK11_TAR"
fi

export OLD_PATH=$PATH
export JAVA_HOME=$INSTALLDIR/devtools/java/$JDK11_0_2
export PATH=$JAVA_HOME/bin:$PATH

java --version

echo "+++++++++++++++++++++++++++++++++++++++++++++++"
echo "Build Environment JDK 11 ready for action      "
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
exit 0;
