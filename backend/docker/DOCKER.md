# DOCKER

O Docker é uma plataforma de software que permite que você crie, implante e execute aplicativos em contêineres. Contêineres são uma forma de virtualização de sistemas operacionais que permitem empacotar um aplicativo e suas dependências em uma unidade única e portátil que pode ser executada em qualquer sistema que suporte o Docker. Isso significa que você pode construir e testar seu aplicativo em um ambiente controlado e, em seguida, implantá-lo em qualquer sistema operacional que suporte o Docker, sem se preocupar com as diferenças de configuração entre sistemas. O Docker também facilita a gestão de múltiplos contêineres e a orquestração de aplicativos em um ambiente de nuvem, o que é útil para aplicativos distribuídos e escaláveis.



#### Ciclo de vida

`docker run -it ubuntu bash` - baixa e sobe um container e acessa o bash do ubuntu

`docker ps` - lista os processos de docker em execução

`docker ps -a` - lista todos os containers independente do seu status

`docker start <container id | name>` -  subir um container

`docker stop <container id | name>` -  parar um container

`docker rm <container id | name>` - remove container

`docker start -a -i <container id>` - inicia novamente o container com a sua saída

`docker run --name nome_container -it ubuntu bash` - cria container nomeando



#### Imagens

Sempre que criamos um container ele usa uma imagem, afinal um container é uma instancia de uma imagem em execução.

`docker run -p 8080:80 -p 8443:443 -d docker samples/static-site `  - o `-p` mapeia a porta 8080 do host na porta 80 do container. O `-d` não atacha o client na saída do container para o terminal não ficar preso.

`docker images` - lista todas as imagens locais

`docker rmi <nome da imagem | id>` - remove imagens



#### Gestão de volumes e imagens personalizadas 

Para construir nossa imagens temos que criar um arquivo com as informações da imagem. Geralmente esses arquivos tem o nome de `Dockerfile`

```dockerfile
FROM nginx:latest # imagem de origem 
MAINTAINER Rayane Paiva <rayanepaiiva@live.com> # quem esta mantendo
COPY . /usr/share/nginx/html # copia tudo da pasta onde esta o dockerfile para esse outro diretorio 
WORKDIR /user/share/nginx/html # seta como diretorio diretorio padrao da imagem tudo dentro desse diretorio será servido automaticamente
EXPOSE 80 # expoe na porta 80
```

`docker build -t rayanepaiva/nginx:1.0.0 .` -  constrói uma imagem a partir de um dockerfile. O `-t` é para criar uma tag  com o nome e a versão `rayanepaiva/nginx:1.0.0` no final o `.` informa que é a partir desse diretório que criaremos a imagem.

`docker run -d -p 8080:80 rayanepaiva/nginx1.0.0` -  criando uma instancia da imagem



Volumes são diretórios do nosso host mapeados dentro do nosso container. Ou seja conseguimos acessar conteúdo de dentro do nosso container mapeado no nosso host

`docker run -d -p 8082:80 -v /c/Users/rayane.paiva/Git/docker-curso/site:/usr/share/nginx/html --name megasite rayanepaiva/nginx:1.0.0`

Parâmetros:

`-d`  - rodar em segundo plano

`-p` -  rodar na porta x

`-v` - indica que é um volume `-v <pasta no host>:<pasta no docker>`

