## Docker - Comandos básicos

* `docker ps` - mostra os containers que estão sendo executados no momento
* `docker run <imagem>` - baixa a imagem (se ela nao existir localmente) e executa 
* `docker ps -a` - mostra todos os containers ativos ou que ja executaram em algum momento
* `docker run -it ubuntu bash` - baixa a imagem do ubuntu e acessa o terminal bash dentro dele (o processo do bash esta segurando o processo do container)
*  `docker run -it --rm ubuntu bash` - o parametro `--rm` remove o container quando o processo que o segura terminar

---

A nossa máquina é o docker host, ela roda os processos do docker. O container que está rodando internamente é uma maquina. Então quando temos uma API rodando em um container na porta 8080 não significa que conseguimos acessar esse endpoint no host, ou seja, se o container tem portas ativas isso não significa que o host consegue acessar a porta do container. Um outro container conseguiria fazer esse acesso. Porém conseguimos fazer um apontamento de portas, um redirecionamento, atraves do comando: 

```
docker run -p <porta do meu host que sera acessada>:<porta do container para onde sera feito o redirecionamento> nginx
```

O parametro `-p` faz a publicação da porta.

O comando acima mantem o terminal atachado (travado) exibindo os logs do processo que estiver rodando. Para destachar o terminal podemos usar o parametro `-d`:

```shell
docker run -d -p 8080:80 nginx
```

Podemos executar e parar a execução dos containers com os comandos: 

```shell
docker start <nome ou id do container>
docker stop <nome ou id do container>
```

Para remover containers ou forçar a remoção do container: 

```shell
docker rm <nome ou id do container>
docker rm <nome ou id do container> -f
```

Para dar um nome aos containers ao subir podemos usar:

```shell
docker run -d --name <nome do container> nginx
```

Executando um comando no container:

```
docker exec <nome do container> <comando>
docker exec nginx ls
```

Em alguns comando pode ser necessário usar o parametro para rodar em modo iterativo `-it`:

```shell
docker exec -it teste bash
```

---

### Bind mounts

O **Bind Mounts** no Docker é uma maneira de compartilhar diretórios ou arquivos do seu sistema operacional com os contêineres Docker.

Imagine que você tem uma pasta no seu computador chamada `meus_dados` com arquivos importantes. Se você iniciar um contêiner Docker e quiser que ele possa acessar esses arquivos, você pode usar o Bind Mounts para "montar" essa pasta dentro do contêiner.

Quando o Bind Mounts está em uso, o que você alterar na pasta no seu computador será imediatamente refletido no contêiner, e vice-versa. Isso é útil, por exemplo, para desenvolvimento, onde você deseja que as mudanças que faz no código no seu computador sejam imediatamente visíveis no contêiner. 

O comando abaixo mostra como montar uma pasta que está no computador (host) dentro do container: 

```
docker run -d --name meu_container -p 8080:80 -v <caminho da pasta no host>:<caminho da pasta no container> nginx
```

Todas as alterações feitas na pasta do host vão ser refletidas para dentro do container e caso o container seja apagado não perdemos os arquivos na pasta que está no host.

O comando `-v` não é tão usado atualmente. Existe outra opção:

```
docker run -d -p 80:80 --mount type=bind,source="$(pwd)"/html,target=/user/html nginx
```

A diferença entre o `-v` e o `--mount` é que o primeiro cria os caminhos caso eles não existam, então se eu passar um caminho com nome errado eu estarei criando um novo caminho no host, já o segundo retorna um erro caso eu tente espelhar um caminho inexistente.

O **Bind mounts** é útil para compartilhar dados entre o contêiner e o sistema host, especialmente durante o desenvolvimento ou quando você precisa que o contêiner tenha acesso a arquivos específicos.

---

### Volumes

Os **Volumes** são uma forma de armazenar e gerenciar dados usados por contêineres de maneira independente do ciclo de vida desses contêineres. Nos conseguimos criar volumes no docker.

Imagine que você tem um banco de dados rodando dentro de um contêiner Docker. Os dados desse banco precisam ser salvos em algum lugar, mesmo que o contêiner seja removido ou reiniciado. É aí que os Volumes entram.

Quando usamos um Volume, o Docker cria um espaço de armazenamento especial fora do sistema de arquivos do contêiner, mas que é acessível por ele. Isso significa que, mesmo que o contêiner seja excluído, os dados salvos no Volume permanecem intactos e podem ser acessados por outros contêineres.

**Principais benefícios dos Volumes:**

- **Persistência:** Os dados não são apagados quando o contêiner é removido.
- **Compartilhamento:** Vários contêineres podem acessar o mesmo Volume, facilitando o compartilhamento de dados entre eles.
- **Backup e migração:** Como os Volumes são gerenciados pelo Docker, é fácil fazer backup ou mover os dados entre diferentes ambientes.

Comandos para lidar com os volumes: 

* `create` - Create a volume
* `inspect` - Display detailed information on one or more volumes
* `ls` - List volumes
* `prune` - Remove unused local volumes
* `rm` - Remove one or more volumes

**Exemplo de uso de volumes:**

Quando queremos persistir arquivos do container no computador, manter o tipo de arquivos no mesmo tipo de file systems (na linux virtual machine) que o docker utiliza, ter mais performace, não queremos nos preocupar em gerenciar o locar de armazenamento, podemos criar um volume e apontar o volume dentro do container. Esse volume pode também ser mapeado para outros containers.

Criando um volume: 

```
docker volume create <nome volume>
```

Listando os volumes: 

```
docker volume ls
```

Para visualizar no terminal os detalhes sobre o volume criado: 

```shell
docker volume inspect <nome volume>
```

```
[
    {
        "CreatedAt": "2024-08-17T20:52:06Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/novo_volume/_data",
        "Name": "novo_volume",
        "Options": null,
        "Scope": "local"
    }
]
```

O `Mountpoint` é o local onde ficam gravados os arquivos no computador (host). 

Podemos mapear o volume para dentro de uma pasta no meu container: 

```shell
docker run --name nginx -d --mount type=volume,source=novo_volume,target=/app nginx
```

> O comando acima pode não funcionar no `git bash` e retornar esse erro: 
>
> `docker: Error response from daemon: invalid mount config for type "volume": invalid mount path: 'C:/Program Files/Git/app' mount path must be absolute.`
>
> Esse erro sugere que o Docker está tentando montar um diretório relacionado ao Git Bash (`C:/Program Files/Git/app`). Isso pode acontecer se executanmos o comando em um terminal que usa a formatação de caminhos do Windows.
>
> Para resolver isso podemos executar o comando em outro terminal, como o PowerShell, ou podemos adicionar um sinalizador ao comoando no git bash: 
>
> ```shell
> MSYS_NO_PATHCONV=1 docker run --name nginx -d --mount type=volume,source=novo_volume,target=/app nginx
> ```
>
> O `MSYS_NO_PATHCONV=1` desativa a conversão de caminho do Git Bash, garantindo que o Docker interprete o comando como você escreveu.

Agora se entrarmos no container: 

```shell
docker exec -it nginx bash
```

poderemos ver que vamos ter uma pasta `/app`  ao digitar o comando `ls` no terminal. Essa pasta armazena todos os dados que vamos criar no volume. Podemos adicionar um arquivo de teste:

```shell
touch oi
```

Ao sair desse container e criar um **novo container** nginx2, acessar o bash do container, acessar a pasta app e listar o conteúdo dela:

```shell
docker run --name nginx -d --mount type=volume,source=novo_volume,target=/app nginx
docker exec -it nginx bash
cd /app/
ls
```

poderemos ver que o arquivo que criamos dentro do primeiro container está presente. Simplesmente estamos compartilhando o volume com os dois containers criados. Ou seja, os arquivos criados dentro desse volume, independende de estar no primeiro container ou no segundo, vão ser compartilhados entre os dois.

Conseguimos usar o comando `-v` para acessar os volumes:

```shell
docker run --name nginx3 -d -v novo_volume:/app nginx
```

> Dica: as vezes estamos utilizando varios containers na máquina e então percebemos que a máquina está ficando cheia mas não sabemos de onde estão os arquivos que estão ocupando espaço. Normalmente isso acontece quando os arquivos de volume/diretorios de volume enchem e então eles começam a encher a maquina.
>
> Nesse caso, para tudo que não esta sendo usado podemos usar o comando `prune`:
>
> ```shell
> docker volume prune
> ```
>
> esse comando mata tudo que não esta sendo usado nos volumes.
