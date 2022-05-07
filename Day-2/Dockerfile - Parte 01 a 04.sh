



##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#######################  Dockerfile - Parte 01

https://docs.docker.com/engine/reference/builder/

RUN - são comandos executados durante o Build.
Usando mais de um comando no mesmo RUN cria somente 1 camada, é o preferível.
O comando apt-get clean limpa os pacotes .deb que foram usados em algum momento na instalação.
É necessário usar o apt-get clean no mesmo RUN dos install, porque os RUN não interagem entre si.

ENV - são as variáveis de ambiente

LABEL - The LABEL instruction adds metadata to an image. A LABEL is a key-value pair. An image can have more than one label.

VOLUME - cria um volume com base no diretório informado.

ENTRYPOINT - é o principal processo do container. Equivale ao init para máquina Linux.



cd /curso/descomplicando-o-docker/dockerfiles/1
vi Dockerfile

# DOCKERFILE

FROM debian

RUN apt-get update && apt-get install -y apache2 && apt-get clean
ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

LABEL description="Webserver"
LABEL version="1.0.0"

VOLUME /var/www/html/
EXPOSE 80




os comandos
- O comando abaixo expõe a porta 8080 pra fora, apontando para a 80 do container:
docker container run -ti -p 8080:80

-O comando abaixo usando o P maiusculo vai verificar se tem alguma porta com o EXPOSE no Dockerfile e vai bindar com uma porta aleatória:
docker container run -ti -P







##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#######################  Dockerfile - Parte 02

cd /curso/descomplicando-o-docker/dockerfiles/1
docker image build -t meu_apache:1.0.0 .


root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/1# docker image build -t meu_apache:1.0.0
"docker image build" requires exactly 1 argument.
See 'docker image build --help'.
Usage:  docker image build [OPTIONS] PATH | URL | -
Build an image from a Dockerfile
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/1# docker image build -t meu_apache:1.0.0 .
Sending build context to Docker daemon  2.048kB
Step 1/11 : FROM debian
 ---> fe3c5de03486
Step 2/11 : RUN apt-get update && apt-get install -y apache2 && apt-get clean
 ---> Running in f387838fd74f
Get:1 http://deb.debian.org/debian bullseye InRelease [113 kB]
Get:2 http://security.debian.org/debian-security bullseye-security InRelease [44.1 kB]
Get:3 http://deb.debian.org/debian bullseye-updates InRelease [36.8 kB]
Get:4 http://security.debian.org/debian-security bullseye-security/main amd64 Packages [31.1 kB]
Get:5 http://deb.debian.org/debian bullseye/main amd64 Packages [8178 kB]
Fetched 8402 kB in 2s (4886 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  apache2-bin apache2-data apache2-utils bzip2 ca-certificates file libapr1
  libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libbrotli1 libcurl4
  libexpat1 libgdbm-compat4 libgdbm6 libgpm2 libicu67 libjansson4
  libldap-2.4-2 libldap-common liblua5.3-0 libmagic-mgc libmagic1 libncurses6
  libncursesw6 libnghttp2-14 libperl5.32 libprocps8 libpsl5 librtmp1
  libsasl2-2 libsasl2-modules libsasl2-modules-db libsqlite3-0 libssh2-1
  libxml2 mailcap media-types mime-support netbase openssl perl
  perl-modules-5.32 procps psmisc publicsuffix ssl-cert xz-utils
Suggested packages:
  apache2-doc apache2-suexec-pristine | apache2-suexec-custom www-browser
  bzip2-doc gdbm-l10n gpm sensible-utils libsasl2-modules-gssapi-mit
  | libsasl2-modules-gssapi-heimdal libsasl2-modules-ldap libsasl2-modules-otp
  libsasl2-modules-sql perl-doc libterm-readline-gnu-perl
  | libterm-readline-perl-perl make libtap-harness-archive-perl
The following NEW packages will be installed:
  apache2 apache2-bin apache2-data apache2-utils bzip2 ca-certificates file
  libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libbrotli1
  libcurl4 libexpat1 libgdbm-compat4 libgdbm6 libgpm2 libicu67 libjansson4
  libldap-2.4-2 libldap-common liblua5.3-0 libmagic-mgc libmagic1 libncurses6
  libncursesw6 libnghttp2-14 libperl5.32 libprocps8 libpsl5 librtmp1
  libsasl2-2 libsasl2-modules libsasl2-modules-db libsqlite3-0 libssh2-1
  libxml2 mailcap media-types mime-support netbase openssl perl
  perl-modules-5.32 procps psmisc publicsuffix ssl-cert xz-utils
0 upgraded, 49 newly installed, 0 to remove and 1 not upgraded.
Need to get 24.6 MB of archives.
After this operation, 111 MB of additional disk space will be used.
Get:1 http://deb.debian.org/debian bullseye/main amd64 libgdbm6 amd64 1.19-2 [64.9 kB]
Get:2 http://security.debian.org/debian-security bullseye-security/main amd64 perl-modules-5.32 all 5.32.1-4+deb11u1 [2823 kB]
Get:3 http://deb.debian.org/debian bullseye/main amd64 libgdbm-compat4 amd64 1.19-2 [44.7 kB]
Enabling site 000-default.
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of start.
Processing triggers for libc-bin (2.31-13) ...
Processing triggers for ca-certificates (20210119) ...
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
Removing intermediate container f387838fd74f
 ---> 1290fb49f502
Step 3/11 : ENV APACHE_LOCK_DIR="/var/lock"
 ---> Running in f40518d81570
Removing intermediate container f40518d81570
 ---> 8567bed219d4
Step 4/11 : ENV APACHE_PID_FILE="/var/run/apache2.pid"
 ---> Running in 21ef85f37cbb
Removing intermediate container 21ef85f37cbb
 ---> 0ce3013858b2
Step 5/11 : ENV APACHE_RUN_USER="www-data"
 ---> Running in 57aa6dfbf94b
Removing intermediate container 57aa6dfbf94b
 ---> 7f0dbc98aa01
Step 6/11 : ENV APACHE_RUN_GROUP="www-data"
 ---> Running in ddd71715b411
Removing intermediate container ddd71715b411
 ---> 77407b6da12c
Step 7/11 : ENV APACHE_LOG_DIR="/var/log/apache2"
 ---> Running in 871fcd290ffc
Removing intermediate container 871fcd290ffc
 ---> 5eb95f88c845
Step 8/11 : LABEL description="Webserver"
 ---> Running in d7854a84effe
Removing intermediate container d7854a84effe
 ---> 5a1ba7f2e18a
Step 9/11 : LABEL version="1.0.0"
 ---> Running in 90c4f145a192
Removing intermediate container 90c4f145a192
 ---> 6ad11c7a00b7
Step 10/11 : VOLUME /var/www/html/
 ---> Running in f4f0b7f1d47a
Removing intermediate container f4f0b7f1d47a
 ---> 9539a061edb2
Step 11/11 : EXPOSE 80
 ---> Running in 03d496199a3d
Removing intermediate container 03d496199a3d
 ---> 5e577cf5591e
Successfully built 5e577cf5591e
Successfully tagged meu_apache:1.0.0
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/1#


docker image ls

root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/1# docker image ls
REPOSITORY             TAG       IMAGE ID       CREATED          SIZE
meu_apache             1.0.0     5e577cf5591e   45 seconds ago   252MB

root@de8e61dc620d:/# dpkg -l | grep apa
ii  apache2                       2.4.48-3.1+deb11u1             amd64        Apache HTTP Server
ii  apache2-bin                   2.4.48-3.1+deb11u1             amd64        Apache HTTP Server (modules and other binary files)
ii  apache2-data                  2.4.48-3.1+deb11u1             all          Apache HTTP Server (common files)
ii  apache2-utils                 2.4.48-3.1+deb11u1             amd64        Apache HTTP Server (utility programs for web servers)
ii  libcap-ng0:amd64              0.7.9-2.2+b1                   amd64        An alternate POSIX capabilities library
root@de8e61dc620d:/#



-Criada uma imagem sem o apt-get clean, para verificar se a imagem fica mais pesada, por manter sujeiras, porém a imagem do debian no Docker já está limpando o cache sozinha:

docker image build -t meu_apache_sujo:1.0.0 .

root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/1# docker image ls
REPOSITORY             TAG       IMAGE ID       CREATED         SIZE
meu_apache_sujo        1.0.0     2db4000863cf   9 seconds ago   252MB
meu_apache             1.0.0     5e577cf5591e   2 minutes ago   252MB





root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/1# docker container run -ti meu_apache_sujo:1.0.0

root@de8e61dc620d:/# dpkg -l | grep apa
ii  apache2                       2.4.48-3.1+deb11u1             amd64        Apache HTTP Server
ii  apache2-bin                   2.4.48-3.1+deb11u1             amd64        Apache HTTP Server (modules and other binary files)
ii  apache2-data                  2.4.48-3.1+deb11u1             all          Apache HTTP Server (common files)
ii  apache2-utils                 2.4.48-3.1+deb11u1             amd64        Apache HTTP Server (utility programs for web servers)
ii  libcap-ng0:amd64              0.7.9-2.2+b1                   amd64        An alternate POSIX capabilities library
root@de8e61dc620d:/#






root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/1# cd ..
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles# cp -R 1 2
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles# ls
1  2
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles# cd 2/
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/2# ls
Dockerfile
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/2#
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/2# vi Dockerfile
root@ubuntulab:/curso/descomplicando-o-docker/dockerfiles/2#


FROM debian

RUN apt-get update && apt-get install -y apache2
ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

LABEL description="Webserver"
LABEL version="1.0.0"

VOLUME /var/www/html/
EXPOSE 80

ENTRYPOINT ["/usr/bin/apache/ctl"]
CMD ["-D", "FOREGROUND"]






Quando não existe um ENTRYPOINT, o CMD assume que pode usar comandos usando o Bash por padrão.
Quando existe o ENTRYPOINT, o CMD só serve para passar parametro para o ENTRYPOINT. Por isto que o CMD ficou apenas ["-D", "FOREGROUND"]
Ao utilizar o ENTRYPOINT com CMD, não é possível utilizar o CMD sozinho passando comando, é necessário escolher entre um dos dois modos. 
Este modo com ENTRYPOINT é chamado de exec.
Usando o CMD passando comando sem o uso do ENTRYPOINT é chamado de shell.


-Modo Exec:
ENTRYPOINT ["/usr/bin/apache/ctl"]
CMD ["-D", "FOREGROUND"]

-Modo Shell:
CMD /usr/bin/apache/ctl -D FOREGROUND


-A opção FOREGROUND do Apache diz pra ele trabalhar em primero plano.



##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#######################  Dockerfile - Parte 03

-Buildando uma imagem com o Dockerfile da aula anterior, iremos buildar a versão 2.0.0:
cd /curso/descomplicando-o-docker/dockerfiles/2
docker image build -t meu_apache:2.0.0 .


-Buildando a imagem sem usar o cache, é necessário informar o parametro --no-cache:
docker image build -t meu_apache:2.0.0 . --no-cache





-CRIADA A IMAGEM NA VM CENTOS 7:
[root@cen7 2]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
meu_apache          2.0.0               32c3eb8f73c8        11 seconds ago      252 MB
docker.io/debian    latest              82bd5ee7b1c5        2 weeks ago         124 MB
[root@cen7 2]#


-EXECUTANDO O CONTAINER DO APACHE, A PARTIR DA IMAGEM CRIADA, BINDANDO A PORTA 80, PORÉM APRESENTOU ERRO NO EXEC DO ENTRYPOINT:

docker container run -d -p 8080:80 meu_apache:2.0.0

[root@cen7 2]# docker container run -d -p 8080:80 meu_apache:2.0.0
1ea412882e65c259f9905e28eb736207c50e1e388a018242484a9bcced224ad7
/usr/bin/docker-current: Error response from daemon: oci runtime error: container_linux.go:235: starting container process caused "exec: \"/usr/bin/apache/ctl\": stat /usr/bin/apache/ctl: no such file or directory".
[root@cen7 2]#




-VERIFICANDO O DOCKER HUB ABAIXO, FOI NECESSÁRIO AJUSTAR O EXEC DO ENTRYPOINT PARA O APACHE2 e BUILDAR NOVAMENTE A IMAGEM:
https://hub.docker.com/r/eboraas/apache/dockerfile/

vi Dockerfile
ENTRYPOINT ["/usr/sbin/apache2ctl"]
docker image build -t meu_apache:2.0.0 . --no-cache
docker container run -d -p 8080:80 meu_apache:2.0.0

[root@cen7 2]# docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
381d1d4eb414        meu_apache:2.0.0    "/usr/sbin/apache2..."   6 seconds ago       Up 5 seconds        0.0.0.0:8080->80/tcp   modest_nightingale
[root@cen7 2]#




##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#######################  Dockerfile - Parte 04

Adicionando um COPY ao Dockerfile

COPY index.html /var/www/html


docker image build -t meu_apache:3.0.0 .
docker container run -d -p 8080:80 meu_apache:3.0.0
docker container run -d -p 8000:80 meu_apache:3.0.0
curl localhost:8000

[root@cen7 3]# curl localhost:8000
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
[root@cen7 3]#




docker container exec -ti c28 bash

[root@cen7 3]# docker container exec -ti c28 bash
root@c28508a4dece:/# cd /var/www/html/
root@c28508a4dece:/var/www/html# ls
index.html
root@c28508a4dece:/var/www/html#


vi Dockerfile
ADD index.html /var/www/html/
WORKDIR /var/www/html/

O comando ADD no Dockerfile é semelhante ao COPY, mas ele tem 2 diferenças:
    ao copiar um arquivo TAR ele já explode o arquido tar, copiando os arquivos contidos nele, ao invés de copiar o próprio TAR.
    ele também consegue copiar um arquivo remoto, por exemplo um arquivo de uma URL e copia para dentro do Container.

O comando WORKDIR informa qual o diretório o Container já vai sair trabalhando ao ser iniciado.



[root@cen7 4]# pwd
/curso/descomplicando-o-docker/dockerfiles/4
[root@cen7 4]#

docker image build -t meu_apache:4.0.0 .

docker container run -d -p 8000:80 meu_apache:4.0.0
[root@cen7 4]# docker container run -d -p 8000:80 meu_apache:4.0.0
fbdc8e650efc08317a18b5e503bb634ccd5eed305d1f350d941cba4133d0721e


curl localhost:8000
[root@cen7 4]# curl localhost:8000
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




[root@cen7 4]# docker container exec -ti fbd bash
root@fbdc8e650efc:/var/www/html# ls
index.html
root@fbdc8e650efc:/var/www/html# pwd
/var/www/html
root@fbdc8e650efc:/var/www/html#





# AJUSTANDO O USER DO DOCKERFILE, USAR O WWW-DATA



FROM debian

RUN apt-get update && apt upgrade && apt-cache policy apache2 && apt-get install -y apache2 && apt-get clean
ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

ADD index.html /var/www/html/

LABEL description="Webserver"
LABEL version="1.0.0"

USER www-data

WORKDIR /var/www/html/

VOLUME /var/www/html/
EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]





[root@cen7 4]# docker logs heuristic_panini
mkdir: cannot create directory '/var/run/apache2': Permission denied
apache2: Syntax error on line 80 of /etc/apache2/apache2.conf: DefaultRuntimeDir must be a valid directory, absolute or relative to ServerRoot
Action '-D FOREGROUND' failed.
The Apache error log may have more information.
[root@cen7 4]#




FROM debian

RUN apt-get update && apt upgrade && apt-cache policy apache2 && apt-get install -y apache2 && apt-get clean
ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

ADD index.html /var/www/html/

LABEL description="Webserver"
LABEL version="1.0.0"

USER root

WORKDIR /var/www/html/

VOLUME /var/www/html/
EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]