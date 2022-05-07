



Dockerfile - MultiStage - Parte 02
AULA - Dockerfile - MultiStage - Parte 02


cp -R 4 5

fernando@ubuntulab:~/descomplicando-o-docker/day2$ ls
1  2  3  4
fernando@ubuntulab:~/descomplicando-o-docker/day2$ cp -R 4 5
fernando@ubuntulab:~/descomplicando-o-docker/day2$ ls
1  2  3  4  5
fernando@ubuntulab:~/descomplicando-o-docker/day2$



########################################################
#### MultiStage
-O Multistage é como se tivesse um Pipeline dentro do Dockerfile.
-Usando a opção "AS" no "FROM" apelidamos esta parte.
-No nosso exemplo vamos dividir em 2 Stages, 1 é do Golang e outro do Alpine, no Alpine iremos usar o COPY e referenciar 
o Stage "buildando".
-Iremos copiar o "meugo" do primeiro container.
exemplo:
COPY --from=<stage_de_referencia> <origem_da_cópia> <destino_da_cópia>
-Devido o fato do WORKDIR especificar o diretório giropops, no entrypoint não é necessário passar o caminho completo.

FROM golang AS buildando

WORKDIR /app
ADD . /app
RUN go env -w GO111MODULE=auto
RUN go build -o meugo

FROM alpine
WORKDIR /giropops
COPY --from=buildando /app/meugo /giropops


ENTRYPOINT ./meugo






########################################################
#### Buildando

-Ajustar a versão para 2.0.

docker image build -t meugo:2.0 .


fernando@ubuntulab:~/descomplicando-o-docker/day2/5$ docker image build -t meugo:2.0 .
Sending build context to Docker daemon  3.072kB
Step 1/9 : FROM golang AS buildando
 ---> ec365f06285d
Step 2/9 : WORKDIR /app
 ---> Using cache
 ---> 143704dea283
Step 3/9 : ADD . /app
 ---> bc106e65c156
Step 4/9 : RUN go env -w GO111MODULE=auto
 ---> Running in 87a3c5279a06
Removing intermediate container 87a3c5279a06
 ---> 196b66b00f2e
Step 5/9 : RUN go build -o meugo
 ---> Running in 06941dfb58b9
Removing intermediate container 06941dfb58b9
 ---> 2c59bde9e633
Step 6/9 : FROM alpine
latest: Pulling from library/alpine
97518928ae5f: Pull complete
Digest: sha256:635f0aa53d99017b38d1a0aa5b2082f7812b03e3cdb299103fe77b5c8a07f1d2
Status: Downloaded newer image for alpine:latest
 ---> 0a97eee8041e
Step 7/9 : WORKDIR /giropops
 ---> Running in ff8966bca9bd
Removing intermediate container ff8966bca9bd
 ---> 6612980606e1
Step 8/9 : COPY --from=buildando /app/meugo /giropops
 ---> 6560b2f981bd
Step 9/9 : ENTRYPOINT ./meugo
 ---> Running in 90ba8feffd59
Removing intermediate container 90ba8feffd59
 ---> 38bb9ca04ec4
Successfully built 38bb9ca04ec4
Successfully tagged meugo:2.0
fernando@ubuntulab:~/descomplicando-o-docker/day2/5$


fernando@ubuntulab:~/descomplicando-o-docker/day2/5$ docker image ls
REPOSITORY                    TAG       IMAGE ID       CREATED          SIZE
meugo                         2.0       38bb9ca04ec4   40 seconds ago   7.37MB
<none>                        <none>    2c59bde9e633   50 seconds ago   942MB
alpine                        latest    0a97eee8041e   11 days ago      5.61MB
meugo                         1.0       bfc464214a93   7 weeks ago      942MB
<none>                        <none>    e3bc4e6a25f7   7 weeks ago      941MB
<none>                        <none>    47383e04747d   7 weeks ago      941MB
gcr.io/k8s-minikube/kicbase   v0.0.27   9fa1cc16ad6d   2 months ago     1.08GB
golang                        latest    ec365f06285d   2 months ago     941MB
toskeira                      1.0       afe5b4d11509   2 months ago     142MB
debian                        latest    fe3c5de03486   3 months ago     124MB
nginx                         latest    08b152afcfae   4 months ago     133MB
mysql                         5.7       8cf625070931   4 months ago     448MB
kindest/node                  <none>    32b8b755dee8   6 months ago     1.12GB
centos                        latest    300e315adb2f   11 months ago    209MB
kamui/postgresql              latest    580b3638c359   7 years ago      387MB
fernando@ubuntulab:~/descomplicando-o-docker/day2/5$






########################################################
#### -RODANDO A APLICAÇÃO EM GO:

docker container run -ti meugo:1.0
docker container run -ti meugo:2.0

-Diferença de tamanho entre as imagens do "meugo":

fernando@ubuntulab:~/descomplicando-o-docker/day2/5$ docker image ls | grep meugo
meugo                         2.0       38bb9ca04ec4   2 minutes ago   7.37MB
meugo                         1.0       bfc464214a93   7 weeks ago     942MB
fernando@ubuntulab:~/descomplicando-o-docker/day2/5$


-Resumindo:
na primeira parte do Dockerfile é executada uma ação
na segunda parte do Dockerfile é otimiza a ação, no caso, foi usado o Alpine para tornar a imagem mais leve.