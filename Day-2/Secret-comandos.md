echo 'minha secret' | docker secret create 
docker secret create minha_secret minha_secret.txt
docker secret inspect minha_secret
docker secret ls
docker secret rm minha_secret
docker service create --name app --detach=false --secret db_pass  minha_app:1.0
docker service create --detach=false --name app --secret source=db_pass,target=password,uid=2000,gid=3000,mode=0400 minha_app:1.0
ls -lhart /run/secrets/
docker service update --secret-rm db_pass --detach=false --secret-add source=db_pass_1,target=password app