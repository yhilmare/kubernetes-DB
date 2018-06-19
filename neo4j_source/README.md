# Neo4j-Source

## Introduction

The writter has described how to build a neo4j cluster in another [README.md](https://github.com/yhswjtuILMARE/kubernetes-DB/blob/master/README.md). The writter does not prepare to note it again. I want to note more details about the new 
image.

As the writter describe in another README.md, the neo4j cluster need at least eight environment variables to build a cluster, and five of them can not be determined begore. These environment variables involve the IP address of the cluster. Well, we can specify the node that the neo4j instances run so that we can obtain the ip address of each node in the cluster. This kind of method goes against the design idea of kubernetes. We have to think out another method to solve this problem to let kubernetes schedule neo4j instances automatically without setting any variables manually. Creating a new neo4j image is such a suitable solution.

## New docker image

We can find the [neo4j:enterprise official image](https://github.com/neo4j/docker-neo4j-publish.git) on git. We choose the edition `3.3.3` to be our basic docker image. You can execute this command `git clone https://github.com/yhswjtuILMARE/kubernetes-DB.git` to clone this repositoriy to your local. As you can see in my repositoriy, there is a shell named `run.sh`. The main work I did is to intergate this shell file to the docker image. This shell will be executed when the container starts. It will obtain its own ip address and another ip addresses by reading a file that written by all initial cluster members. It can set environment variables when it obtains the info mentioned above.

I have published this docker image to my public docker hub with the name `nwpuyh/neo4j:enterprise`. You can execute this command to pull this image.

```
docker pull nwpuyh/neo4j:enterprise
```

That is what I did about this project, and please contact me If there are any problems I did not note clearly. I have connected neo4j's storage to glusterfs.
