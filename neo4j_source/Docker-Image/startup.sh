#!/bin/bash

#判断环境变量中无头Service是否设置

sleep 20

if [ ${#PEER_DISCOVERY_SERVICE} == 0 ]; then
  echo `date` "[Error] - "\"PEER_DISCOVERY_SERVICE \" "was not found."
else
  cd /var/lib/neo4j/java
  java ParseIPAddress ${PEER_DISCOVERY_SERVICE} ${1} ${NEO4J_causal__clustering_expected__core__cluster__size} ${PRESENT_NAME}
  echo `date` "[INFO] - "\"ParseIPAddress\" "has been started."
fi
