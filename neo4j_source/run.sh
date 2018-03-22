var=""
dest=`hostname`
for line in `cat /etc/hosts`; do
  if [ ${line} == ${dest} ]; then
    break
  fi
  var=${line}
done
export NEO4J_dbms_mode="CORE"
export NEO4J_causal__clustering_expected__core__cluster__size=1
export NEO4J_causal__clustering_initial__discovery__members=${var}:5000
export NEO4J_causal__clustering_discovery__advertised__address=${var}:5000
export NEO4J_causal__clustering_transaction__advertised__address=${var}:6000
export NEO4J_causal__clustering_raft__advertised__address=${var}:7000
export NEO4J_dbms_connectors_default__advertised__address=${var}
echo \"run.sh\"已经执行
