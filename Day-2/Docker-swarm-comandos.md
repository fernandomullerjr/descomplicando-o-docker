docker swarm init

docker swarm join --token \ SWMTKN-1-100_SEU_TOKEN SEU_IP_MASTER:2377

docker node ls

docker swarm join-token manager

docker swarm join-token worker

docker node inspect LINUXtips-02

docker node promote LINUXtips-03

docker node ls

docker node demote LINUXtips-03

docker swarm leave

docker swarm leave --force

docker node rm LINUXtips-03

docker service create --name webserver --replicas 5 -p 8080:80  nginx

curl QUALQUER_IP_NODES_CLUSTER:8080

docker service ls

docker service ps webserver

docker service inspect webserver

docker service logs -f webserver

docker service rm webserver

docker service create --name webserver --replicas 5 -p 8080:80 --mount type=volume,src=teste,dst=/app  nginx

docker network create -d overlay giropops

docker network ls

docker network inspect giropops

docker service scale giropops=5

docker network rm giropops

docker service create --name webserver --network giropops --replicas 5 -p 8080:80 --mount type=volume,src=teste,dst=/app  nginx

docker service update <OPCOES> <Nome_Service> 