#!/bin/bash

#判断环境变量中无头Service是否设置

sleep 20

echo "dbms.jvm.additional=-Dcom.sun.management.jmxremote.port=3637" >> /var/lib/neo4j/conf/neo4j.conf
echo "dbms.jvm.additional=-Dcom.sun.management.jmxremote.authenticate=false" >> /var/lib/neo4j/conf/neo4j.conf
echo "dbms.jvm.additional=-Dcom.sun.management.jmxremote.ssl=false" >> /var/lib/neo4j/conf/neo4j.conf
echo "dbms.jvm.additional=-Dcom.sun.management.jmxremote.password.file=/absolute/path/to/conf/jmx.password" >> /var/lib/neo4j/conf/neo4j.conf
echo "dbms.jvm.additional=-Dcom.sun.management.jmxremote.access.file=/absolute/path/to/conf/jmx.access" >> /var/lib/neo4j/conf/neo4j.conf
echo "dbms.jvm.additional=-Djava.rmi.server.hostname=127.0.0.1" >> /var/lib/neo4j/conf/neo4j.conf

cd / && java -jar neo4jAgent-0.0.1-jar-with-dependencies.jar &

if [ ${#PEER_DISCOVERY_SERVICE} == 0 ]; then
  echo `date` "[Error] - "\"PEER_DISCOVERY_SERVICE \" "was not found."
else
  cd /var/lib/neo4j/java
  java ParseIPAddress ${PEER_DISCOVERY_SERVICE} ${1} ${NEO4J_causal__clustering_expected__core__cluster__size} ${PRESENT_NAME}
  echo `date` "[INFO] - "\"ParseIPAddress\" "has been started."
fi
