#!/bin/bash
#java path
export JAVA_HOME={{ java_dir }}/jdk
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib
