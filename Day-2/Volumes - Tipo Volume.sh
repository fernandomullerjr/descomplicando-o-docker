


! Volumes - Tipo Volume



##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
####################### Criando um Volume e listando os volumes:

docker volume create giropops
docker volume ls

root@ubuntulab:/opt/giropops# docker volume create giropops
giropops
root@ubuntulab:/opt/giropops# docker volume ls
DRIVER    VOLUME NAME
local     6fd802e2552ebd97080212d445058a38e3db67a87ebd0f740d51b2964220ae85
local     f50ff38c25046cd0ce15a2a9364cd8db98b20048f65262027e4c412aeea25ba3
local     giropops
root@ubuntulab:/opt/giropops#





##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
####################### Comando Docker Inspect

-Inspecionando o volume com o docker inspect:

docker volume inspect giropops

root@ubuntulab:/opt/giropops# docker volume inspect giropops
[
    {
        "CreatedAt": "2021-08-28T02:54:18Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/giropops/_data",
        "Name": "giropops",
        "Options": {},
        "Scope": "local"
    }
]
root@ubuntulab:/opt/giropops#


-Verificando o ponto de montagem do volume, usando a op????o -f ou --format do docker inspect ?? poss??vel filtrar a sa??da do comando docker inspect:
docker volume inspect --format '{{ .Mountpoint }}' giropops
fernando@ubuntulab:~$ docker volume inspect --format '{{ .Mountpoint }}' giropops
/var/lib/docker/volumes/giropops/_data
fernando@ubuntulab:~$








-Acessando o diret??rio do volume no host local e criando alguns arquivos aleat??rios:

root@ubuntulab:/var/lib/docker/volumes/giropops/_data# pwd
/var/lib/docker/volumes/giropops/_data
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# ls
giropops.txt  testando.log  testezin.txt
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#



-Criando Container com volume do tipo Volume:
obs: ?? poss??vel utilizar este mesmo volume para mais de 1 container, pode compartilhar com v??rios Containers!
docker container run -ti --mount type=volume,src=<nome_do_volume_criado>,dst=/<diretorio_no_container> debian
docker container run -ti --mount type=volume,src=giropops,dst=/giropops debian


-Acessando o diret??rio giropops no Container e verificando os arquivos do Volume:

root@ubuntulab:/home/fernando# docker container run -ti --mount type=volume,src=giropops,dst=/giropops debian
root@34c80c900d3d:/# ls
bin  boot  dev  etc  giropops  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@34c80c900d3d:/# cd giropops/
root@34c80c900d3d:/giropops# ls
giropops.txt  testando.log  testezin.txt
root@34c80c900d3d:/giropops#



-Criados arquivos nos Containers, verificado que os arquivos s??o gerados no diret??rio do Volume no Host Local:

root@ubuntulab:/home/fernando# docker container ls
CONTAINER ID   IMAGE     COMMAND   CREATED              STATUS              PORTS     NAMES
3dee1868df36   debian    "bash"    29 seconds ago       Up 28 seconds                 happy_chaum
0365a8915edb   debian    "bash"    About a minute ago   Up About a minute             frosty_mclean
root@ubuntulab:/home/fernando#

root@ubuntulab:/var/lib/docker/volumes/giropops/_data# ls
container-365  container-3de  giropops.txt  test33  testando.log  testezin.txt
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#





-N??o ?? poss??vel remover Volume que esteja atrelado a algum Container em execu????o ou atrelado a algum Container parado mesmo:

root@ubuntulab:/home/fernando# docker volume rm giropops
Error response from daemon: remove giropops: volume is in use - [34c80c900d3d470f05015f809f2913dd724ddf2dc05c4a30b7956f00a4067fbb, 0365a8915edba5fd9ac24ff6485f9276f4463e603434e706286f1009e63c55f6, 3dee1868df36cac9bcc4ca31d87f299b0cd2205bcb65d3e50814e6245d31d94b]
root@ubuntulab:/home/fernando#

-Ap??s exclu??dos os Containers, foi poss??vel excluir o volume:

root@ubuntulab:/home/fernando# docker container rm -f 3de
3de
root@ubuntulab:/home/fernando# docker container rm -f 036
036
root@ubuntulab:/home/fernando# docker container rm -f 34c
34c
root@ubuntulab:/home/fernando# docker volume rm giropops
giropops
root@ubuntulab:/home/fernando#

-O Volume giropops j?? n??o consta mais no diret??rio volumes:

root@ubuntulab:/var/lib/docker/volumes/giropops/_data/..# cd /var/lib/docker/volumes/
root@ubuntulab:/var/lib/docker/volumes# ls
6fd802e2552ebd97080212d445058a38e3db67a87ebd0f740d51b2964220ae85  backingFsBlockDev  f50ff38c25046cd0ce15a2a9364cd8db98b20048f65262027e4c412aeea25ba3  metadata.db
root@ubuntulab:/var/lib/docker/volumes#






##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
#############  Criando 3 Containers usando o mesmo volume, criando e excluindo arquivo e verificando a persistencia dos dados

-Criados 3 containers usando o mesmo volume, atrav??s do comando  docker container run -ti --mount type=volume,src=giropops,dst=/giropops debian
docker container run -ti --mount type=volume,src=giropops,dst=/giropops debian

root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container ls
CONTAINER ID   IMAGE     COMMAND   CREATED          STATUS          PORTS     NAMES
5059eada6c1e   debian    "bash"    27 seconds ago   Up 27 seconds             quirky_tharp
ea4aa8cd2ef5   debian    "bash"    53 seconds ago   Up 52 seconds             thirsty_ramanujan
aa0b2a36facb   debian    "bash"    12 minutes ago   Up 12 minutes             objective_visvesvaraya
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker volume ls
DRIVER    VOLUME NAME
local     giropops
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#


-Entrando no container usando o comando docker container exec -ti aa0b2a36facb bash:

root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container exec -ti aa0b2a36facb bash
root@aa0b2a36facb:/# ls
bin  boot  dev  etc  giropops  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var


-Acessado o diret??rio que est?? ligado ao volume criado e criado um arquivo de teste:

root@aa0b2a36facb:/# cd giropops/
root@aa0b2a36facb:/giropops# touch container-aa0-teste.txt
root@aa0b2a36facb:/giropops# ls
STRIGUS  container-aa0-teste.txt  giropops.log


-Saindo do container sem matar ele, usando as teclas CTRL+P+Q:

root@aa0b2a36facb:/giropops# read escape sequence
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#


-Exclu??do o container e os arquivos seguem armazenados no diret??rio do volume, sem problemas:

root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container rm -f aa0
aa0
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# docker container ls
CONTAINER ID   IMAGE     COMMAND   CREATED          STATUS          PORTS     NAMES
5059eada6c1e   debian    "bash"    36 minutes ago   Up 36 minutes             quirky_tharp
ea4aa8cd2ef5   debian    "bash"    36 minutes ago   Up 36 minutes             thirsty_ramanujan
root@ubuntulab:/var/lib/docker/volumes/giropops/_data# ls
container-aa0-teste.txt  giropops.log  STRIGUS
root@ubuntulab:/var/lib/docker/volumes/giropops/_data#
