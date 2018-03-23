if [ ${1} == "a" ]; then
  docker run --name neo4j --net=host -d -p 7474:7474 -p 7687:7687 -p 6000:6000 -p 7000:7000 -p 5000:5000 -p 7473:7473 \
           -e NEO4J_causal__clustering_transaction__advertised__address=172.19.0.134:6000 \
           -e NEO4J_causal__clustering_raft__advertised__address=172.19.0.134:7000 \
           -e NEO4J_ACCEPT_LICENSE_AGREEMENT=yes -e NEO4J_dbms_mode=CORE \
           -e NEO4J_causal__clustering_expected__core__cluster__size=2 \
           -e NEO4J_causal__clustering_initial__discovery__members=172.19.0.133:5000,172.19.0.134:5000 \
           -e NEO4J_causal__clustering_discovery__advertised__address=172.19.0.134:5000 \
           -e NEO4J_dbms_connectors_default__advertised__address=172.19.0.134 \
           neo4j:enterprise
else
  echo lalalal
  docker run --name neo4j_1 -d -p 7474:7474 -p 7687:7687 -p 7473:7473 \
             -e NEO4J_dbms_mode=CORE -e NEO4J_causal__clustering_expected__core__cluster__size=2 \
             -e NEO4J_causal__clustering_initial__discovery__members=172.17.0.2:5000 \
             -e NEO4J_causal__clustering_discovery__advertised__address=172.17.0.2:5000 \
             -e NEO4J_causal__clustering_transaction__advertised__address=172.17.0.2:6000 \
             -e NEO4J_causal__clustering_raft__advertised__address=172.17.0.2:7000 \
             -e NEO4J_dbms_connectors_default__advertised__address=172.17.0.2 \
             -e NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
             neo4j:enterprise
fi
