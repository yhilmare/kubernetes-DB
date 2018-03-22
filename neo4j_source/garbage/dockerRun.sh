flag=$1
if [ ${#flag} == 0 ]; then
  exit
elif [ ${flag} == "cs" ]; then
  docker run --name neo4j_2 -d -p 9474:7474 -p 9473:7473 -p 9687:7687 --net=cluster \
             -e NEO4J_ACCEPT_LICENSE_AGREEMENT=yes -e NEO4J_dbms_mode=CORE \
             -e NEO4J_causal__clustering_expected__core__cluster__size=3 \
             -e NEO4J_causal__clustering_initial__discovery__members=neo4j_0:5000,neo4j_1:5000,neo4j_2:5000 \
                neo4j:enterprise
elif [ ${flag} == "rr" ]; then
  docker run --name neo4j_rr_1 -d -p 11474:7474 -p 11473:7473 -p 11687:7687 --net=cluster \
             -e NEO4J_causal__clustering_initial__discovery__members=neo4j_0:5000,neo4j_1:5000,neo4j_2:5000 \
             -e NEO4J_ACCEPT_LICENSE_AGREEMENT=yes -e NEO4J_dbms_mode=READ_REPLICA \
             neo4j:enterprise
else
  exit
fi
