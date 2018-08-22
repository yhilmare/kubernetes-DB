# Kubernetes-DB

## Introduction
This project is about the intergation of two kinds of databases on kubernetes, mysql and neo4j respectively. The writter will tell you how to run these two databases on kubernetes without telling you how to run kubernetes, so that you need to install the kubernetes previously.

This project contains two packages, "mysql_source" and "neo4j_source" respectively. The package "mysql_source" is about how to intergrate mysql into kubernetes, and the package "neo4j_source" does the similar things. The intergration of mysql is very simple, because mysql is a kind of single point database.

The neo4j has two editions, community edition and enterprise edition respectively, and the former edition is a kind of single point database, the latter is a distributted edition. The writter choosed the enterprise edition neo4j to build a distributted application on kubernetes. This will be quite complex, because the way to building a cluster of neo4j needs to know the IP of every original neo4j instance, but we can not choose a specific node to run neo4j for using kubernetes. Fortunately, we can solve this problem by constructing a new neo4j image based on the official neo4j image, and I have constructed and published this new image named <code>nwpuyh/neo4j:enterprise</code> on my Docker Hub. You can run `docker pull nwpuyh/neo4j:enterprise` to use this image.

## How to run

### Mysql

There are two ways to intergrate mysql into kubernetes, the one is constructing automatically and the other is constructing manually. The writter will introduce the automatical way first. You will find out that there is a shell named `setup.sh`. You can do this simply.

```shell
./setup.sh
```

This shell will check if your cluster contains any ReplicationController, Pod or Service named like "mysql". If so, the shell will not create a new one, otherwise the shell will create a new one for you. You can run `kubectl get po -o wide` to check if the shell run correctly. You will see this if there are not any mistakes.

```
NAME                   READY         STATUS           RESTARTS    AGE       IP               NODE
mysql                  1/1           Running          0           1d        10.244.202.31    lab4
```

You can also choose to build application manually if you want to know more details. You can execute these codes sequentially.

```
kubectl create -f mysql-pvc.yaml
kubectl create -f mysql-server.yaml
kubectl create -f mysql-svc.yaml
```

You will see the same info when you execute the code <code>kubectl get po -o wide</code> if there are not any misktakes.

### neo4j

The way to constructing neo4j is quite complex, because the neo4j is a kind of distributed database. We have to consider how to build a neo4j cluster. There is an official solution given by neo4j official. You can [click here](https://neo4j.com/docs/operations-manual/current/installation/docker/) to know more.

We can know that we have to give a specific number of the instance in the cluster, and we have to determine the IP of every initial neo4j instance in cluster by environment variables from the URL given above. This requirment is difficult to meet in the kubernetes context, since the kubernetes will choose the suitable node to run neo4j instance automaticlly. We do not know which node will be choosen before so that we can not know the IP that the neo4j needs previously. We can build a new neo4j image to solve this problem.

According to the tips given by neo4j official, we are supposed to set these environment variables to make sure that the causal cluster can be built successfully and these environment variables are as follow:

```
env:
    - name: NEO4J_dbms_mode
    - name: NEO4J_causal__clustering_expected__core__cluster__size
    - name: NEO4J_causal__clustering_initial__discovery__members
    - name: NEO4J_causal__clustering_discovery__advertised__address
    - name: NEO4J_causal__clustering_transaction__advertised__address
    - name: NEO4J_causal__clustering_raft__advertised__address
    - name: NEO4J_dbms_connectors_default__advertised__address
    - name: NEO4J_ACCEPT_LICENSE_AGREEMENT
```

There are eight environment variables above, and we can only determine few of them before such as `NEO4J_dbms_mode`, `NEO4J_causal__clustering_expected__core__cluster__size` and `NEO4J_ACCEPT_LICENSE_AGREEMENT`. We can not determine the remaining variables before we run the neo4j instance, but we actually need to know them before we run the neo4j instance. This conflict requires us to use a new image. This kind of new image is built based on the official edition. The detail of this image has been described in another [README.md](https://github.com/yhswjtuILMARE/kubernetes-DB/blob/master/neo4j_source/README.md). 

You can construct a neo4j causal cluster manually by executing these commands.

```
kubectl create -f neo4j-peer-svc.yaml
kubectl create -f neo4j-statefulset.yaml
```

You get a neo4j casual cluster containing one master node, two core-server slave nodes and one read-replica slave node now. The first command is required, and you can choose whether to execute the following two commands. You can see these info by executing this command `kubectl get po -o wide`, if there are not any misktakes.

```
NAME                      READY         STATUS             RESTARTS   AGE       IP               NODE
neo4j-ss-0                1/1           Running            0          7h        172.19.0.134     lab4
neo4j-ss-1                1/1           Running            0          7h        10.244.202.14    lab4
neo4j-ss-2                1/1           Running            0          7h        10.244.202.17    lab4
```

As you can see, we have already got four neo4j instances. Neo4j provides us a web interface to manage the cluster, we can login this web site if we belong to the same local network with the cluster. We can type `http://yourIP:7474` in your browser to visit this web application. We can monitor our cluster's status in this web application.

![neo4j cluster](https://github.com/yhswjtuILMARE/kubernetes-DB/blob/master/images/neo4j_cluster_status.jpg)

As you can see in the picture, we got a casual cluster containing five neo4j instances, and every instance's role can be find in the picture. You can execute command `kubectl scale rc neo4j-cs/neo4j-rr --replicas=***` to scale the size of your cluster. We just build an original cluster so far, and you can realize a `service` object to make the cluster stronger. You can achieve this goal by doing this:

```
kubectl create -f neo4j-svc.yaml
```

## What's More?

If you want to know more about the neo4j cluster, you can achieve these info by visiting their [official website](https://neo4j.com/docs/operations-manual/current/clustering/causal-clustering/setup-new-cluster/).
