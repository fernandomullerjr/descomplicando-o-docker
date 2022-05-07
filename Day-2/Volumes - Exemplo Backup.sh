



##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
####################### Efetuando backup de dados de um volume, criando um container
 
-É necessário montar 2 volumes num container para que seja feito o backup
No primeiro volume é a origem da onde será feito o backup
No segundo volume é passado o diretório local onde vai ser armazenado o backup e o diretório de dentro do container onde vai ser armazenado o backup
Informar a imagem que será usada no Container
Usar o comando linux tar para gerar um tar no diretório /backup do container com o conteúdo do diretório /data:

mkdir /opt/backup
docker container run -ti --mount type=volume,src=desafiodb,dst=/data --mount type=bind,src=/opt/backup,dst=/backup debian tar -cvf /backup/backup-do-volume.tar /data


root@ubuntulab:/home/fernando# docker container run -ti --mount type=volume,src=desafiodb,dst=/data --mount type=bind,src=/opt/backup,dst=/backup debian tar -cvf /backup/backup-do-volume.tar /data
tar: Removing leading / from member names
/data/
/data/pg_hba.conf
/data/pg_serial/
/data/pg_notify/
/data/pg_notify/0000
/data/pg_stat_tmp/
/data/pg_stat_tmp/global.stat
/data/base/
/data/base/12068/
/data/base/12068/11933
/data/base/12068/12043
/data/base/12068/11971
/data/pg_subtrans/0000
/data/teste-desafio.txt
root@ubuntulab:/home/fernando#


-VERIFICANDO SE O ARQUIVO TAR FOI CRIADO:

cd /opt/backup
root@ubuntulab:/opt/backup#
root@ubuntulab:/opt/backup# ls -lhasp
total 42M
4.0K drwxr-xr-x 2 root root 4.0K Sep 11 02:57 ./
4.0K drwxr-xr-x 6 root root 4.0K Sep 11 02:49 ../
 42M -rw-r--r-- 1 root root  42M Sep 11 02:57 backup-do-volume.tar
root@ubuntulab:/opt/backup#


-DESCOMPACTANDO O ARQUIVO TAR:

tar -xvf backup-do-volume.tar

root@ubuntulab:/opt/backup# ls
backup-do-volume.tar  data
root@ubuntulab:/opt/backup# cd data/
root@ubuntulab:/opt/backup/data# ls
base    pg_clog      pg_ident.conf  pg_notify  pg_snapshots  pg_stat_tmp  pg_tblspc    PG_VERSION  postgresql.conf  postmaster.pid  server.key
global  pg_hba.conf  pg_multixact   pg_serial  pg_stat       pg_subtrans  pg_twophase  pg_xlog     postmaster.opts  server.crt      teste-desafio.txt
root@ubuntulab:/opt/backup/data#






##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#######################  Volumes - Questões

Quando criamos um volume do tipo bind, quais os parâmetros para indicar onde o volume será montado no container?

dst
Destination



##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#######################  Volumes - Exemplo de comandos
 
docker container run -ti --mount type=bind,src=/volume,dst=/volume ubuntu
docker container run -ti --mount type=bind,src=/root/primeiro_container,dst=/volume ubuntu
docker container run -ti --mount type=bind,src=/root/primeiro_container,dst=/volume,ro ubuntu
docker volume create giropops
docker volume rm giropops
docker volume inspect giropops
docker volume prune
docker container run -d --mount type=volume,source=giropops,destination=/var/opa  nginx
docker container create -v /data --name dbdados centos
docker run -d -p 5432:5432 --name pgsql1 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql
docker run -d -p 5433:5432 --name pgsql2 --volumes-from dbdados -e  POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql
docker run -ti --volumes-from dbdados -v $(pwd):/backup debian tar -cvf /backup/backup.tar /data