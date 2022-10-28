
# By default elastic serach is running at port 9200
# By default elastic serach has clustername=elasticsearch and nodename is random uuid
# By default elastic search node bind to localhost dns name
# Each elastic serach node is running independently
# Elastic search expose api on port 9200

# The Default path of installation:
Home:	home of elasticsearch installation		/usr/share/elasticsearch
Bin:	Binary scrpits including es to start a node	/usr/share/elasticsearch/bin
conf:	configuration file elasticsearch.yml and logging.yml	/etc/elasticsearch
data:	The location of the data files of each index or shard allocated on the node	/var/lib/elasticsearch/data
logs:	log file location				/var/log/elasticsearch
plugings:	pluginfile location. each plugin will be contained in sub directory	/usr/share/elasticsearch/plugins

# configuration changes for cluster
cluster.name: my-elasticsearch  #cluster_name
node.name: node1		#node_name
index.number_of_shards: 5	#by default number of shards=5 for a index
index.number_of_replicas: 1	#by default replica 1

----creating master node----
node.master: true		
node.data: false

http.port: 9200

----network----
network.host: private-ip-of-node  # this ip is bind to communicate in cluster

---Discovery---
# Default discovery mode is unicast mode(means whatever ip is given for discovery it only communicate(or send packet) to that node only
# zen discovery is built in module for elastic search it provides unicast discovery can be extended to support cloud environment other type of discovery
discovery.zen.ping.unicast.hosts: ["private-ip-of-all-nodes-in-cluster-at-least-master-ip-should-have", "host2"] #master ip should be present in this discovery zen because this node is register by master only

# If you want to disable explicit multicast discovery mode then add below stmt
discovery.zen.ping.multicast.enabled: false

******************************************************************########################################################*****************************************************

# install head plugin in web browser for managing cluster creating index and doing queries
cd /usr/share/elasticsearch/bin
elasticsearch-plugin install mobz/elasticsearch-head                #installing head plugin in this node
# note if we want to manage this cluster by this plugin then http:://ip:9200/_plugin/head then we can see ui of head plugin in our browser
# we can also use chrome head plugin ( if we do not want to install plugin in our node)


# After start elastic serach test is it running or not by below commond
curl -XGET "localhost:9200"
