# Docker - Networks

### Entendendo tipos de Network

O docker possui uma rede interna rodando dentro dele. Sua função principal é fazer um container se comunicar com o outro. Para que um container se comunique com o outro é necessário que eles estejam na mesma rede. Temos alguns tipos de networks:

* **Bridge** - criada por padrão quando não informamos a rede. normalmente usada quando queremos que um container se comunique facilmente com outro.
* **Host** - mescla a *network* do docker com a do host do docker, ou seja, minha maquina é o host do docker e está rodando uma aplicação `php` na porta 80, quando eu crio a *network* do tipo `host` e subo meu container nessa mesma *network* o contariner que esta nela vai poder acessar meu host. Então minha maquina vai poder acessar uma porta do container sem ter que fazer uma exposição de porta.
* **Overlay** - usado para situações onde temos varios dockers em maquinas diferentes e precisamos que eles se comuniquem como se estivessem na mesma rede.
* **Macvlan** - permite que o container tenha o proprio endereçõ MAC e IP como se fosse um dispositivo fisico independente.
* **None** - quando queremos que o container rode de maneira isolada.

### Trabalhando com Bridge

Podemos criar uma nova rede: 

```bash
docker network create --drive bridge minharede
```

Para visualizar:

```bash
docker network ls
```

Criando container e indicando a rede:

```bash
docker run -d -it --name ubuntu-1 --network minharede
docker run -d -it --name ubuntu-2 --network minharede
```

Conectando um container em uma network:

```bash
docker run -d -it --name ubuntu-3
docker network connect minharede ubuntu3
```

### Container acessando nossa maquina

As vezes vamos estar usando o container docker e pode surgir a necessidade de acessar algum recurso do nosso host. Como fazer isso ?

Vamos supor que eu tenha um servidor rodando local na nossa maquina, ou seja, fora do docker. E agora precisamos fazer o docker acessar esse servidor para pegar alguma informação rodando na nossa maquina.

```bash
docker run --rm -it --name ubuntu ubuntu bash
apt-get update
apt-get install curl -y
curl http://host.docker.internal:8000
```

`host.docker.internal` é para apontar para o meu host!