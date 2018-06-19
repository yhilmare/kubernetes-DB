#!/bin/bash

#获取到自己的ip地址

hostname=`hostname`
for line in `cat /etc/hosts`; do
  if [ ${line} == ${hostname}.neo4j-peer-svc.default.svc.cluster.local ]; then
    break
  fi
  ipAddress=${line}
done

#将解析完成的环境变量赋值
export NEO4J_causal__clustering_initial__discovery__members=${1}
export NEO4J_causal__clustering_discovery__advertised__address=${ipAddress}:5000
export NEO4J_causal__clustering_transaction__advertised__address=${ipAddress}:6000
export NEO4J_causal__clustering_raft__advertised__address=${ipAddress}:7000
export NEO4J_dbms_connectors_default__advertised__address=${ipAddress}

echo `date` "[INFO] - \"run.sh\" completed."

cd /var/lib/neo4j

/docker-entrypoint.sh ${2}
