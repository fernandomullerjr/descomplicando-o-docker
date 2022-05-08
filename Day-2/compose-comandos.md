Compose - Comandos
HTML
# mkdir /root/Composes
# mkdir /root/Composes/1
# cd /root/Composes/1
YAML
# vim docker-compose.yml

version: "3"
services:
  web:
    image: nginx
    deploy:
      replicas: 5
      resources:
        limits:	
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
    - "8080:80"
    networks:
    - webserver
networks:
  webserver:
HTML
# docker stack deploy -c docker-compose.yml primeiro
# curl 0:8080
# docker service ls
# docker service ps primeiro_web
# docker stack ls
# docker stack services primeiro
# docker stack ps primeiro
# docker stack rm primeiro
YAML
# vim docker-compose.yml

version: '3'
services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
volumes:
  db_data:
HTML
# docker stack deploy -c docker-compose.yml segundo
# docker stack ls
# docker stack services segundo
# docker service ls
# docker service ps segundo_db
# docker service ps segundo_wordpress
# docker service logs segundo_wordpress

YAML
# mkdir 3
# cd 3
# vim docker-compose.yml

version: "3"
services:
  web:
    image: nginx
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "8080:80"
    networks:
      - webserver

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8888:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webserver

networks:
  webserver:
YAML
# mkdir 4
# cd 4
# vim compose-file.yml

version: "3"
services:
  redis:
    image: redis:alpine
    ports:
      - "6379"
    networks:
      - frontend
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure
  db:
    image: postgres:9.4
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    deploy:
      placement:
        constraints: [node.role == manager]
  vote:
    image: dockersamples/examplevotingapp_vote:before
    ports:
      - 5000:80
    networks:
      - frontend
    depends_on:
      - redis
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
      restart_policy:
        condition: on-failure
  result:
    image: dockersamples/examplevotingapp_result:before
    ports:
      - 5001:80
    networks:
      - backend
    depends_on:
      - db
    deploy:
      replicas: 1
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure
  worker:
    image: dockersamples/examplevotingapp_worker
    networks:
      - frontend
      - backend
    deploy:
      mode: replicated
      replicas: 1
      labels: [APP=VOTING]
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
        window: 120s
      placement:
        constraints: [node.role == manager]
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
networks:
  frontend:
  backend:
volumes:
  db-data:
HTML
# docker stack deploy -c docker-compose.yml quarto
# docker service ls

Visualizar a página de votação:
http://IP_CLUSTER:5000/

Visualizar a página de resultados:
http://IP_CLUSTER:5001/

Visualizar a página de com os containers e seus nodes:
http://IP_CLUSTER:8080/
YAML
# git clone https://github.com/badtuxx/giropops-monitoring.git
# cd giropops-monitoring

# cat docker-compose.yml

version: '3.3'

services:

  prometheus:
    image: linuxtips/prometheus_alpine
    volumes:
      - ./conf/prometheus/:/etc/prometheus/
      - prometheus_data:/var/lib/prometheus
    networks:
      - backend
    ports:
      - 9090:9090

  node-exporter:
    image: linuxtips/node-exporter_alpine
    hostname: '{{.Node.ID}}'
    volumes:
      - /proc:/usr/proc
      - /sys:/usr/sys
      - /:/rootfs
    deploy:
      mode: global
    networks:
      - backend
    ports:
      - 9100:9100

  alertmanager:
    image: linuxtips/alertmanager_alpine
    volumes:
      - ./conf/alertmanager/:/etc/alertmanager/
    networks:
      - backend
    ports:
      - 9093:9093

  cadvisor:
    image: google/cadvisor
    hostname: '{{.Node.ID}}'
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - backend
    deploy:
      mode: global
    ports:
      - 8080:8080

  grafana:
    image: grafana/grafana
    depends_on:
      - prometheus
    volumes:
      - grafana_data:/var/lib/grafana
    env_file:
      - grafana.config
    networks:
      - backend
      - frontend
    ports:
      - 3000:3000

# If you already have a RocketChat instance running, just comment the code of rocketchat, mongo and mongo-init-replica services bellow
  rocketchat:
    image: rocketchat/rocket.chat:latest
    volumes:
      - rocket_uploads:/app/uploads
    environment:
      - PORT=3080
      - ROOT_URL=http://YOUR_IP:3080
      - MONGO_URL=mongodb://mongo:27017/rocketchat
      - MONGO_OPLOG_URL=mongodb://mongo:27017/local
#      - MAIL_URL=smtp://user:pass@smtp.email
#      - HTTP_PROXY=http://proxy.domain.com
#      - HTTPS_PROXY=http://proxy.domain.com
    depends_on:
      - mongo
    ports:
      - 3080:3080

  mongo:
    image: mongo:3.2
    volumes:
     - mongodb_data:/data/db
     #- ./data/dump:/dump
    command: mongod --smallfiles --oplogSize 128 --replSet rs0

  mongo-init-replica:
    image: mongo:3.2
    command: 'mongo mongo/rocketchat --eval "rs.initiate({ _id: ''rs0'', members: [ { _id: 0, host: ''localhost:27017'' } ]})"'
    depends_on:
      - mongo

networks:
  frontend:
  backend:

volumes:
    prometheus_data:
    grafana_data:
    rocket_uploads:
    mongodb_data:
HTML
# docker stack deploy -c docker-compose.yml giropops
# docker service ls 
# docker stack ls

Prometheus:
http://SEU_IP:9090

AlertManager:
http://SEU_IP:9093

Grafana:
http://SEU_IP:3000

Node_Exporter:
http://SEU_IP:9100

Rocket.Chat:
http://SEU_IP:3080

cAdivisor:
http://SEU_IP:8080

# docker stack rm giropops


Lembrando, para conhecer mais sobre o giropops-monitoring acesse o repositório no GitHub e assista a série de vídeos em que  falo detalhadamente como montei essa solução:
Repo: https://github.com/badtuxx/giropops-monitoring
Vídeos: https://www.youtube.com/playlist?list=PLf-O3X2-mxDls9uH8gyCQTnyXNMe10iml