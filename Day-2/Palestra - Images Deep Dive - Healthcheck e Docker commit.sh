



Palestra Images Deep Dive, Healthcheck e Docker commit


# Palestra Images Deep Dive, Healthcheck e Docker commit



# Healthcheck

- É possível adicionar instruções no Dockerfile para que ele possa fazer um Healthcheck, para validar a saúde do Container:

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1





########################################################
#### Criando Dockerfile com Healthcheck

-Aproveitado o Dockerfile da aula3,

FROM debian

RUN apt-get update && apt upgrade && apt-cache policy apache2 && apt-get install -y apache2 && apt-get clean
ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

COPY index.html /var/www/html/

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

LABEL description="Webserver"
LABEL version="1.0.0"

VOLUME /var/www/html/
EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]




########################################################
#### Buildando

-Buildando as imagens antigas, só para ter o histórico de versões:

cd /home/fernando/descomplicando-o-docker/day2/1
docker image build -t meu_apache:1.0.0 .

cd /home/fernando/descomplicando-o-docker/day2/2
docker image build -t meu_apache:2.0.0 .


#### Criando o Dockerfile com Healthcheck

-Ajustar a versão para 5.0.

docker image build -t meu_apache:5.0.0 .



Processing triggers for libc-bin (2.31-13+deb11u2) ...
E: Command line option 'y' [from -y] is not understood in combination with the other options.
The command '/bin/sh -c apt-get update -y && apt upgrade -y && apt-cache policy apache2 -y && apt-get install -y apache2 && apt-get clean -y' returned a non-zero code: 100
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$


-Foi necessário ajustar os "-y"


FROM debian

RUN apt-get update -y && apt upgrade -y && apt-cache policy apache2 && apt-get install apache2 -y && apt-get clean
ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

COPY index.html /var/www/html/

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

LABEL description="Webserver"
LABEL version="1.0.0"

VOLUME /var/www/html/
EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]



Step 8/15 : COPY index.html /var/www/html/
COPY failed: file not found in build context or excluded by .dockerignore: stat index.html: file does not exist
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ vi index.html



#### criado o index.html

vi index.html

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Document</title>
</head>
<body>
<!-- Conteúdo -->
</body>
</html>



docker image build -t meu_apache:5.0.0 .


fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ docker image build -t meu_apache:5.0.0 .
Sending build context to Docker daemon  3.584kB
Step 1/15 : FROM debian
 ---> fe3c5de03486
Step 2/15 : RUN apt-get update -y && apt upgrade -y && apt-cache policy apache2 && apt-get install apache2 -y && apt-get clean
 ---> Using cache
 ---> a0c5c7570f30
Step 3/15 : ENV APACHE_LOCK_DIR="/var/lock"
 ---> Using cache
 ---> 7b1381085792
Step 4/15 : ENV APACHE_PID_FILE="/var/run/apache2.pid"
 ---> Using cache
 ---> 38ade67d8b4d
Step 5/15 : ENV APACHE_RUN_USER="www-data"
 ---> Using cache
 ---> 3b83c49ab697
Step 6/15 : ENV APACHE_RUN_GROUP="www-data"
 ---> Using cache
 ---> 36318c3015e9
Step 7/15 : ENV APACHE_LOG_DIR="/var/log/apache2"
 ---> Using cache
 ---> 37a2fcd47d6a
Step 8/15 : COPY index.html /var/www/html/
 ---> b48490c5f5d5
Step 9/15 : HEALTHCHECK --interval=1m --timeout=3s   CMD curl -f http://localhost/ || exit 1
 ---> Running in b12d619c8007
Removing intermediate container b12d619c8007
 ---> a690a6b6fbfc
Step 10/15 : LABEL description="Webserver"
 ---> Running in d7d008172ff5
Removing intermediate container d7d008172ff5
 ---> 6256fe3d4374
Step 11/15 : LABEL version="1.0.0"
 ---> Running in 68020aebf1b1
Removing intermediate container 68020aebf1b1
 ---> ddadb5f3d9f0
Step 12/15 : VOLUME /var/www/html/
 ---> Running in 8ab1578b393c
Removing intermediate container 8ab1578b393c
 ---> 1b6f0c23fba1
Step 13/15 : EXPOSE 80
 ---> Running in a04c8519d58f
Removing intermediate container a04c8519d58f
 ---> 7935ed1bac1f
Step 14/15 : ENTRYPOINT ["/usr/sbin/apache2ctl"]
 ---> Running in f38f8b3abd96
Removing intermediate container f38f8b3abd96
 ---> 193d6965e02d
Step 15/15 : CMD ["-D", "FOREGROUND"]
 ---> Running in 1d1b670811f1
Removing intermediate container 1d1b670811f1
 ---> 99ccbfae82cd
Successfully built 99ccbfae82cd
Successfully tagged meu_apache:5.0.0
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ ^C
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$





docker container run -ti meu_apache:5.0.0
docker container run -d -p 8000:80 meu_apache:5.0.0

fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ docker container run -d -p 8000:80 meu_apache:5.0.0
f87ad64f3b7d74f4ced8749f32b5b4ea260d71974d82999370087e577aa32780
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS                           PORTS                                   NAMES
f87ad64f3b7d   meu_apache:5.0.0       "/usr/sbin/apache2ct…"   2 seconds ago   Up 1 second (health: starting)   0.0.0.0:8000->80/tcp, :::8000->80/tcp   eager_lumiere
bb740086309d   kindest/node:v1.21.1   "/usr/local/bin/entr…"   2 months ago    Up 24 minutes                    127.0.0.1:42375->6443/tcp               giropops-control-plane
5fe9d2d78158   kindest/node:v1.21.1   "/usr/local/bin/entr…"   2 months ago    Up 24 minutes                    127.0.0.1:34519->6443/tcp               kind-control-plane
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$



fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ ^C
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ curl localhost:8000
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Document</title>
</head>
<body>
<!-- Conteúdo -->
</body>
</html>
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$




-Container segue com o Healthcheck em (health: starting)

fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ docker container ls
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS                            PORTS                                   NAMES
f87ad64f3b7d   meu_apache:5.0.0       "/usr/sbin/apache2ct…"   2 minutes ago   Up 2 minutes (health: starting)   0.0.0.0:8000->80/tcp, :::8000->80/tcp   eager_lumiere
bb740086309d   kindest/node:v1.21.1   "/usr/local/bin/entr…"   2 months ago    Up 27 minutes                     127.0.0.1:42375->6443/tcp               giropops-control-plane
5fe9d2d78158   kindest/node:v1.21.1   "/usr/local/bin/entr…"   2 months ago    Up 27 minutes                     127.0.0.1:34519->6443/tcp               kind-control-plane
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$


-Container com o Healthcheck eternamente em (health: starting)
-Verificado que ocorre isto porque ele não tem o curl instalado:
docker exec -ti f87ad64f3b7d bash

root@f87ad64f3b7d:/# curl localhost
bash: curl: command not found
root@f87ad64f3b7d:/# ^C


-Deletar todos os Containers

docker container rm -f $(docker ps -q)



-Editado o Dockerfile, adicionada instalação do curl e workdir no /var/www/html
vi Dockerfile

docker image build -t meu_apache:5.0.0 .
docker container run -d -p 8000:80 meu_apache:5.0.0


fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ docker container run -d -p 8000:80 meu_apache:5.0.0
c40afea7560d6a27ba1c63f585382127789a6d0c4f20eec42b8bbf61cff9827f
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ docker container ls
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS                            PORTS                                   NAMES
c40afea7560d   meu_apache:5.0.0   "/usr/sbin/apache2ct…"   3 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:8000->80/tcp, :::8000->80/tcp   hungry_diffie
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ ^C


-Agora com o curl instalado, o Container fica em Healthy:

fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$ docker container ls
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS                   PORTS                                   NAMES
c40afea7560d   meu_apache:5.0.0   "/usr/sbin/apache2ct…"   2 minutes ago   Up 2 minutes (healthy)   0.0.0.0:8000->80/tcp, :::8000->80/tcp   hungry_diffie
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$
fernando@ubuntulab:~/descomplicando-o-docker/day2/palestra$



-VIDEO CONTINUA EM
14:46