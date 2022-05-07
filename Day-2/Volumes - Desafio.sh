


################################################################################################################################################
################################################################################################################################################
################################################################################################################################################
################################################################################################################################################
################################################################################################################################################
######################## Volumes - Desafio 

Fazer o mesmo cenário dos containers com PostgreSQL, só que agora usando os Volumes, ao invés de volumes Data-Only





docker volume create dbdados

# MÉTODO VIA DATA-ONLY:
-Primeiro container:
docker container run -d -p 5432:5432 --name pgsql1 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql
-ATENÇÃO, NO SEGUNDO CONTAINER TROCAR A PORTA DO LADO DO HOST
docker container run -d -p 5433:5432 --name pgsql2 --volumes-from dbdados -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql





##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
####################### Criando um Volume normal e listando os volumes:

docker volume create giropops
docker volume ls

docker container run -ti --mount type=volume,src=giropops,dst=/giropops debian


docker volume ls
docker volume create desafiodb
docker volume ls
docker container run -d -p 5432:5432 --name pgsql-desafio-1 --mount type=volume,src=desafiodb,dst=/data -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql
docker container run -d -p 5433:5432 --name pgsql-desafio-2 --mount type=volume,src=desafiodb,dst=/data -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker kamui/postgresql