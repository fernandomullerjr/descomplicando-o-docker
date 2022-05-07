

-No notebook local:
Dockerfile-MultiStage.dockerfile

-no Servidor Ubuntu20lab:
Dockerfile

root@ubuntulab:/home/fernando/descomplicando-o-docker/day2/4# pwd
/home/fernando/descomplicando-o-docker/day2/4
root@ubuntulab:/home/fernando/descomplicando-o-docker/day2/4#
root@ubuntulab:/home/fernando/descomplicando-o-docker/day2/4# ls
Dockerfile  meu_go.go
root@ubuntulab:/home/fernando/descomplicando-o-docker/day2/4#


docker image build -t meugo:1.0 .



-ERRO:
go: go.mod file not found in current directory or any parent directory; see 'go help modules'
The command '/bin/sh -c go build -o meugo' returned a non-zero code: 1

-SOLUÇÃO:
adicionado ao Dockerfile:
RUN go env -w GO111MODULE=auto



Dockerfile-MultiStage.dockerfile

############# Imagem da aplicação em GO:
root@ubuntulab:/home/fernando/descomplicando-o-docker/day2/4# docker image ls
REPOSITORY         TAG       IMAGE ID       CREATED         SIZE
meugo              1.0       bfc464214a93   2 minutes ago   942MB


########### -RODANDO A APLICAÇÃO EM GO:
docker container run -ti meugo:1.0
root@ubuntulab:/home/fernando/descomplicando-o-docker/day2/4# docker container run -ti meugo:1.0
Giropops Strigus Girus
root@ubuntulab:/home/fernando/descomplicando-o-docker/day2/4#
