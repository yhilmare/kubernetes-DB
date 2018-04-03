# Neo4j-Source
<h2>Introduction</h2>
<p>The writter has described how to build a neo4j cluster in another <a href="https://github.com/yhswjtuILMARE/kubernetes-DB
/blob/master/README.md">README.md</a>. The writter does not prepare to note it again. I want to note more details about the new 
image.</p>
<p>As the writter describe in another README.md, the neo4j cluster need at least eight environment variables to build a cluster, and five of them can not be determined begore. These environment variables involve the IP address of the cluster. Well, we can specify the node that the neo4j instances run so that we can obtain the ip address of each node in the cluster. This kind of method goes against the design idea of kubernetes. We have to think out another method to solve this problem to let kubernetes schedule neo4j instances automatically without setting any variables manually. Creating a new neo4j image is such a suitable solution.</p>
<h2>New docker image</h2>
<p>We can find the <a href="https://github.com/neo4j/docker-neo4j-publish.git">neo4j:enterprise official image</a> on git. We choose the edition <code>3.3.3</code> to be our basic docker image. You can execute this command <code>git clone https://github.com/yhswjtuILMARE/kubernetes-DB.git</code> to clone this repositoriy to your local. As you can see in my repositoriy, there is a shell named <code>run.sh</code>. The main work I did is to intergate this shell file to the docker image. This shell will be executed when the container starts. It will obtain its own ip address and another ip addresses by reading a file that written by all initial cluster members. It can set environment variables when it obtains the info mentioned above.</p>
<p>I have published this docker image to my public docker hub with the name <code>nwpuyh/neo4j:enterprise</code>. You can execute this command to pull this image.</p>
<pre>
docker pull nwpuyh/neo4j:enterprise
</pre>
<p>That is what I did about this project, and please contact me If there are any problems I did not note clearly.</p>
