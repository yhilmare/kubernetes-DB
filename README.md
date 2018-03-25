# Kubernetes-DB
<h2>Introduction</h2>
This project is about the intergation of two kinds of databases on kuberletes, mysql and neo4j respectively. The writter will tell you hwo to run these two databases on kuberletes without telling you how to run kuberletes, so that you need to install the kuberletes previously.<br/><br/>
This project contains two packages, "mysql_source" and "neo4j_source" respectively. The package "mysql_source" is about how to intergrate mysql into kuberletes, and the package "neo4j_source" does the same thing. Since the mysql is kind of a single point database, the intergration of mysql is very simple. <br/><br/>
The neo4j gets two editions, community edition and enterprise edition respectively, and the former edition is a kind of single point database, the latter is a distributted edition. The writter choosed the enterprise edition neo4j to build a distributted application on kuberletes. This will be quite complex, cause the way to building a cluster of neo4j needs to know the IP of every original neo4j node, and we can not choose a specific node to run neo4j for using kuberletes. Fortunately, we can solve the problem by constructing a new neo4j image based on the offical neo4j image, and I have published this new image named <code>nwpuyh/neo4j:enterprise</code> on my Docker Hub. You can run <code>docker pull nwpuyh/neo4j:enterprise</code> to use this image.
<h2>How to run</h2>
<h3>Mysql</h3>
There are two ways to intergrate mysql into kuberletes, the one is constructing automatically and the other is constructing manually. The writter will introduce the automatical way first. You will find out that there is a shell named <code>run.sh</code>. You can do this simply.<br/>
<pre>./run.sh</pre>
This shell will check if your cluster contains any ReplicationController, Pod or Service named like "mysql". If so, the shell will not create a new one, otherwise the shell will create a new one for you. You can run <code>kubectl get po -o wide</code> to check if the shell run correctly. You will see this if there are not any mistakes.<br/>
<pre>
NAME                             READY     STATUS             RESTARTS   AGE       IP               NODE
mysql-rc-79q97                   1/1       Running            0          1d        10.244.202.31    lab4
</pre>
You can also choose to build application manually if you wat to get more details. You can execute these codes sequentially.<br/>
<pre>
kubectl create -f mysql_pv.yaml
kubectl create -f mysql_pvc.yaml
kubectl create -f mysql_rc.yaml
kubectl create -f mysql_svc.yaml
</pre>
You will see the same info when you execute the code <code>kubectl get po -o wide</code> if there are not any misktakes.
<h3>neo4j</h3>
The way to constructing neo4j is quite complex, cause the neo4j is a kind of distributed database. We have to consider hwo to build a neo4j cluster. There is an offical solution given by neo4j official. You can <a href="https://neo4j.com/docs/operations-manual/current/installation/docker/">click here</a> to know more.<br/><br/>
We can know that we have to give a specific number of the instance in the cluster, and we have to give the IP of every initial neo4j instance in cluster by environment variables. This requirment is difficult to meet in the kuberletes environment, since the kuberletes will choose the node to run neo4j instance automaticlly. We do not know which node will be choosen before so that we can not give the IP that the neo4j needs. We can build a new neo4j image to solve this problem.
