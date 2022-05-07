


##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
############# RESUMO

O Data Only é um meio obsoleto dos Containers compartilharem um volume.
É criado um Container que irá servir como volume, para ser utilizado em outros containers.

Data-only containers are obsolete and are now considered an anti-pattern!



##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
############# Efetuando limpeza de containers e volumes não utilizados

Usar os comandos abaixo para limpar containers e volumes:
docker container prune
docker volume prune

root@ubuntulab:/var/lib/docker/volumes# docker container prune
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
a0a12b2871393799fb9c3989412657acf55193c377bc7168afd36afd1b77665d
e609f8750efe920a4fb9f5a55d6bf5fb708c976c9d780492b651a33e12c9ef5b
301368ee21d8cff923dd7ad390d1891d5dda592277f6d1cafef1958d690554bf
8ab14acbd9d0677e0f0da34a971f67a59da4dfdcea672d224dc8859e92ff45e4
aa58e4779b960261444bb1cc569b8c513faf773b848c0bd5a49f21c2dfbce9d4
a8d097124584846331f1628e7b62eb40d86d0cd13225ac56fbc49e87567ca052
ff4d1c9a08f8b27cf9557492d2cfea423acac796631d50d3d403ff3a8f98b5cb
092235062f05b4145b332af607192bc06afae02e7de3197f4e1cd6fc700964d8
2d2da19ee1389c3ce9a28eff44d6165b04af971b3db9c7f5ec5064b1186c295c
e6b6efd2af53177f7ec5d617236b05d56dc7ccd232b4c0f851093179b9f7caf4
c7460d3884dec3e074bbc648a8765d29ffdbf423de1ed8016e8fc78c497fce8f
d004871731e4f00f0ae7f70e969f9cd7b816a21d4a3fef3b31a878639651a24a
411befd227a04ea76665859223bf9175cd7e94fe13f89d9029dd5361d9756653

Total reclaimed space: 20.68MB




root@ubuntulab:/var/lib/docker/volumes# docker volume prune
WARNING! This will remove all local volumes not used by at least one container.
Are you sure you want to continue? [y/N] y
Deleted Volumes:
6fd802e2552ebd97080212d445058a38e3db67a87ebd0f740d51b2964220ae85
f50ff38c25046cd0ce15a2a9364cd8db98b20048f65262027e4c412aeea25ba3

Total reclaimed space: 428MB
root@ubuntulab:/var/lib/docker/volumes#





##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#############  Volumes - Data-Only e Prune  - Criando os containers usando o Volume Data-Only

docker container run -ti --mount type=volume,src=giropops,dst=/giropops debian

docker inspect ea4aa8cd2ef5

"Mounts": [
            {
                "Type": "volume",
                "Name": "giropops",
                "Source": "/var/lib/docker/volumes/giropops/_data",
                "Destination": "/giropops",
                "Driver": "local",
                "Mode": "z",
                "RW": true,
                "Propagation": ""




docker container create
este comando cria o container mas não executa ele

-Usando o comando na maneira antiga, criando o volume Data Only:
docker container create -v /opt/giropops:giropops --name dbdados centos

-APRESENTOU ERRO, DEVIDO A FALTA DO CAMINHO ABSOLUTO NO CAMINHO DE MONTAGEM DO CONTAINER:
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container create -v /opt/giropops:giropops --name dbdados centos
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
7a0437f04f83: Pull complete
Digest: sha256:5528e8b1b1719d34604c87e11dcd1c0a20bedf46e83b5632cdeac91b8c04efc1
Status: Downloaded newer image for centos:latest
Error response from daemon: invalid volume specification: '/opt/giropops:giropops': invalid mount config for type "bind": invalid mount path: 'giropops' mount path 
must be absolute
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#



docker container create -v /opt/giropops:/giropops --name dbdados centos

root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container create -v /opt/giropops:/giropops --name dbdados centos
78223e9b942a1bf33fc25137474ab6d126cc2e60785175460fba32c2b512a520
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#

-COMO O CONTAINER FOI APENAS CRIADO, ELE NÃO VAI FICAR EM EXECUÇÃO, SENDO NECESSÁRIO VERIFICAR ELE VIA DOCKER CONTAINER LS -A, PARA PEGAR OS CONTAINERS PARADOS TAMBÉM:
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container ls -a
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS             PORTS     NAMES
78223e9b942a   centos    "/bin/bash"   About a minute ago   Created                      dbdados



-Criando os containers com o PostgreSQL:
o parametro -p define as portas
o parametro -e define as variaveis de ambiente

exemplo:
docker container run -d -p <porta-do-host>:<porta-do-container> --name <nome-do-container> --volumes-from dbdados -e <variaveis-de-ambiente> <nome-da-imagem>

-Primeiro container:
docker container run -d -p 5432:5432 --name pgsql1 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql

-ATENÇÃO, NO SEGUNDO CONTAINER TROCAR A PORTA DO LADO DO HOST
docker container run -d -p 5433:5432 --name pgsql2 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql

-ERRO:
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container run -d -p 5432:5432 --name pgsql1 --volumes-from dbdados \ -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker \ -e POSTGRESQL_DB=docker kamui/postgresql
docker: invalid reference format.
See 'docker run --help'.
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#
docker: invalid reference format. Docker is telling you that the syntax of the docker image name (& version) is wrong.
 Note that this is not the same as docker not being able to find the image in the registry. 
Docker will not even be able to lookup the image in the registry if you see an invalid reference format error!

-SOLUÇÃO:
Foi necessário remover as barras invertidas do comando docker container run.


-EXEMPLO DO DOCKER HUB DO KAMUI:
https://hub.docker.com/r/kamui/postgresql
docker-postgresql
PostgreSQL for Docker. The data directory is set to /data so you can use a data only volume.
$ docker run -name postgresql-data -v /data ubuntu /bin/bash
$ docker run -d -p 5432:5432 -volumes-from postgresql-data -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql
da809981545f
$ psql -h localhost -U docker docker


-CRIADOS OS CONTAINERS DO POSTGRESQL:
docker container ls
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container ls
CONTAINER ID   IMAGE              COMMAND                CREATED         STATUS         PORTS                                       NAMES
65e6f253be3a   kamui/postgresql   "/usr/local/bin/run"   6 seconds ago   Up 5 seconds   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp   pgsql2
d33e576183e2   kamui/postgresql   "/usr/local/bin/run"   3 minutes ago   Up 3 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pgsql1



root@ubuntulab:/opt/giropops# docker container ls -a
CONTAINER ID   IMAGE              COMMAND                CREATED          STATUS         PORTS                                       NAMES
65e6f253be3a   kamui/postgresql   "/usr/local/bin/run"   2 minutes ago    Up 2 minutes   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp   pgsql2
d33e576183e2   kamui/postgresql   "/usr/local/bin/run"   5 minutes ago    Up 5 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pgsql1
78223e9b942a   centos             "/bin/bash"            27 minutes ago   Created                                                    dbdados


-NECESSÁRIO REMOVER OS CONTAINERS E O VOLUME DATA ONLY, PORQUE FORAM CRIADOS APONTANDO PARA O GIROPOPS NO CONTAINER, PORÉM NO POSTGRESQL ELE USA O DIRETÓRIO /DATA:
docker container rm -f pgsql2
docker container rm -f pgsql1
docker container rm -f dbdados





-Usando o comando na maneira antiga, criando o volume Data Only:
docker container create -v /opt/giropops:/data --name dbdados centos

-Primeiro container:
docker container run -d -p 5432:5432 --name pgsql1 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql
-ATENÇÃO, NO SEGUNDO CONTAINER TROCAR A PORTA DO LADO DO HOST
docker container run -d -p 5433:5432 --name pgsql2 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql


-MESMO ASSIM QUEBROU OS CONTAINERS, FICANDO EM EXIT:
root@ubuntulab:/opt/giropops# docker container ls -a
CONTAINER ID   IMAGE              COMMAND                CREATED          STATUS                      PORTS     NAMES
5f68e4424c8f   kamui/postgresql   "/usr/local/bin/run"   12 seconds ago   Exited (1) 10 seconds ago             pgsql2
1a37a587c2de   kamui/postgresql   "/usr/local/bin/run"   16 seconds ago   Exited (1) 14 seconds ago             pgsql1



root@ubuntulab:/opt/giropops# docker logs 5f68e4424c8f
2021-09-04 16:40:34 UTC FATAL:  data directory "/data" has wrong ownership
2021-09-04 16:40:34 UTC HINT:  The server must be started by the user that owns the data directory.
root@ubuntulab:/opt/giropops#

!!!!!!!!!!!!!!!!!!!!!!
OBS:
    Como a imagem provavelmente não roda com usuário root, ele não tá conseguindo usar a pasta /data, que está tentando escrever no /opt/giropops, onde não tem permissão.
!!!!!!!!!!!!!!!!!!!!!



-REMOVER OS CONTAINERS NOVAMENTE:
docker container rm -f pgsql2
docker container rm -f pgsql1
docker container rm -f dbdados




-Usando o comando na maneira antiga, criando o volume Data Only, agora sem especificar o diretório local na origem, para evitar problemas de permissões:
docker container create -v /data --name dbdados centos

-Primeiro container:
docker container run -d -p 5432:5432 --name pgsql1 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql
-ATENÇÃO, NO SEGUNDO CONTAINER TROCAR A PORTA DO LADO DO HOST
docker container run -d -p 5433:5432 --name pgsql2 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql

doroot@ubuntulab:/opt/giropops# docker container ls
CONTAINER ID   IMAGE              COMMAND                CREATED         STATUS         PORTS                                       NAMES
67dae370823f   kamui/postgresql   "/usr/local/bin/run"   4 seconds ago   Up 3 seconds   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp   pgsql2
000d08f126c5   kamui/postgresql   "/usr/local/bin/run"   9 seconds ago   Up 8 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pgsql1



-AGORA QUE OS CONTAINERS ESTÃO CRIADOS E O VOLUME COMPARTILHADO ENTRE ELES, PARA SABER O CAMINHO EXATO DO VOLUME EXISTEM 2 FORMAS:

root@ubuntulab:/opt/giropops# cd /var/lib/docker/volumes/
root@ubuntulab:/var/lib/docker/volumes# ls
45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979  backingFsBlockDev                                                 giropops
61ba26adbcfe79469b04a5575983cae90b53443b0a577111eb177340db081edc  dc6caf3d21f91d46a82e2f644cbf26303a51a674d0a5705a69186d2a670295da  metadata.db
root@ubuntulab:/var/lib/docker/volumes#

-INSPECIONANDO O CONTAINER DO POSTGRESQL:

 docker container inspect 67dae370823f

root@ubuntulab:/var/lib/docker/volumes# docker container inspect 67dae370823f

 "Mounts": [
            {
                "Type": "volume",
                "Name": "45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979",
                "Source": "/var/lib/docker/volumes/45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979/_data",
                "Destination": "/data",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""


-INSPECIONANDO O CONTAINER DO DBDADOS:

 docker container inspect -f {{.Mounts}} dbdados
root@ubuntulab:/var/lib/docker/volumes# docker container inspect -f {{.Mounts}} dbdados
[{volume 45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979 /var/lib/docker/volumes/45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979/_data /data local  true }]
root@ubuntulab:/var/lib/docker/volumes#


-EM AMBAS AS FORMAS O RESULTADO É ESTE:
/var/lib/docker/volumes/45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979/_data /data



-VERIFICANDO O DIRETÓRIO, QUE ESTÁ COM OS ARQUIVOS DO POSTGRESQL CORRETAMENTE:

root@ubuntulab:/var/lib/docker/volumes/45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979/_data# ls
base    pg_clog      pg_ident.conf  pg_notify  pg_snapshots  pg_stat_tmp  pg_tblspc    PG_VERSION  postgresql.conf  postmaster.pid  server.key
global  pg_hba.conf  pg_multixact   pg_serial  pg_stat       pg_subtrans  pg_twophase  pg_xlog     postmaster.opts  server.crt
root@ubuntulab:/var/lib/docker/volumes/45b184cb214083fa5494fd334b2419176e32edad008838ec71852b1071782979/_data#
