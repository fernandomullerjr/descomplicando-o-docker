docker image inspect debian
docker history linuxtips/apache:1.0
docker login
docker login registry.suaempresa.com
docker push linuxtips/apache:1.0
docker pull linuxtips/apache:1.0
docker image ls
docker container run -d -p 5000:5000 --restart=always --name registry registry:2
docker tag IMAGEMID localhost:5000/apache