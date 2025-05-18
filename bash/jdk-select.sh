#!/bin/bash
if [ -z "$ORIGINAL_PATH" ]; then
  export ORIGINAL_PATH="$PATH"
fi

export DEVTOOLS_HOME=/d/development/devtools

export JDK16="${DEVTOOLS_HOME}/java/jdk-16.0.1"
export JDK21="${DEVTOOLS_HOME}/java/jdk-21.0.7"
export JDK23="${DEVTOOLS_HOME}/java/jdk-23.0.2"
export JDK24="${DEVTOOLS_HOME}/java/jdk-24.0.1"

export JAVA_HOME="${JDK16}"

alias jdk16='export JAVA_HOME=$JDK16; setJavaPath'
alias jdk21='export JAVA_HOME=$JDK21; setJavaPath'
alias jdk23='export JAVA_HOME=$JDK23; setJavaPath'
alias jdk24='export JAVA_HOME=$JDK24; setJavaPath'

alias setJavaPath='export PATH=$JAVA_HOME/bin:$ORIGINAL_PATH'
alias restorePath='export PATH=$ORIGINAL_PATH'
