## Docker - Instalação

[MANUAL DE REFERENCIA](https://github.com/codeedu/wsl2-docker-quickstart#docker-engine-docker-nativo-diretamente-instalado-no-wsl2)

---

> ### "Docker foi construído e pensado para Linux, não para Windows. E nem pra MAC!"

---

### WSL 2

* Execução completa do Kernel Linux
* Manipulação através do teminal, não há GUI
* Grande desempenho executando aplicativos **dentro** do Linux
* Suporte so Docker e Kubernetes
* Usa o Virtual Machine Platform como base para execução

### Instalação 

No PowerShell ou no prompt de comando do windows **no modo de administrador**: 

```shell
wsl --install
```

Esse comando vai habilitar os recursos necessários para executar o WSL e instalar a distribuição Linux Ubuntu. Em alguns computadores é necessário habilidar a virtualização na BIOS .

Por padrão, a distribuição Linux instalada será o Ubuntu. Isso pode ser alterado usando o sinalizador.`-d`:

```shell
wsl --install -d <Distribution Name>
```

Depois de instalar o WSL, você precisará criar uma conta de usuário e senha para sua distribuição Linux recém-instalada.

Alterando a versão padrão do wsl2:

```shell
wsl --set-default-version 2
```

Podemos dizer que o WSL 2 tem acesso quase que total ao recursos de sua máquina. Ele tem acesso por padrão:

- A 1TB de disco rígido. É criado um disco virtual de 1TB para armazenar os arquivos do Linux (este limite pode ser expandido, ver a área de dicas e truques).
- A usar completamente os recursos de processamento.
- A usar 50% da memória RAM disponível.
- A usar 25% da memória disponível para SWAP (memória virtual).

Se você quiser personalizar estes limites, crie um arquivo chamado `.wslconfig` na raiz da sua pasta de usuário `(C:\Users\<seu_usuario>)` e defina estas configurações:

```conf
[wsl2]
memory=8GB
processors=4
```

Estes são limites de exemplo e as configurações mais básicas a serem utilizadas, configure-os às suas disponibilidades.

Para aplicar estas configurações é necessário reiniciar as distribuições Linux. Execute o comando: `wsl --shutdown` (Este comando vai desligar todas as instâncias WSL 2 ativas, basta abrir o terminal novamente para usa-las já com as novas configurações).

Para mais detalhes veja esta documentação da Microsoft: [Configuração de definições avançadas no WSL | Microsoft Learn](https://learn.microsoft.com/pt-br/windows/wsl/wsl-config#configuration-setting-for-wslconfig)

### Rede em modo LAN e VPN

Como o WSL é virtualizado, há uma outra interface de rede, por isso se você usa rede LAN (cabeada), ao rodar aplicações e tentar acessar pelo navegador, por exemplo, você não conseguirá acessar. Seria necessário ficar fazendo binding de portas o que não seria produtivo.

Eventualmente, podemos ter problemas com VPNs, pois o WSL 2 tem uma interface de rede própria e a VPN pode não funcionar corretamente. Para resolver isto, ative o modo `mirrored` da rede do WSL 2, que fará com que a interface de rede do WSL 2 seja a mesma do Windows. Edite o arquivo `.wslconfig`:

```conf
[wsl2]
networkingMode=mirrored
```

Esta opção só funcionará após reiniciar o WSL com o comando `wsl --shutdown`. Esta opção ajuda a melhorar a experiência com o uso de VPNs.

### Ativar BuildKit no Docker

> **Apenas para Docker Engine**

Acrescente `export DOCKER_BUILDKIT=1` no final do arquivo `.profile` do seu usuário do Linux ou em seu arquivo de terminal personalizado para ganhar mais performance ao realizar builds com Docker. Execute o comando `source ~/.profile` para carregar esta variável de ambiente no ambiente do seu WSL 2.

---

[Rodando Docker no WSL 2 sem Docker Desktop (youtube.com)](https://www.youtube.com/watch?v=wpdcGgRY5kk)

### Instalar o Docker com Docker Engine (Docker Nativo)

A instalação do Docker no WSL 2 é idêntica a instalação do Docker em sua própria distribuição Linux, portanto se você tem o Ubuntu é igual ao Ubuntu, se é Fedora é igual ao Fedora. A documentação de instalação do Docker no Linux por distribuição está [aqui](https://docs.docker.com/engine/install/), mas vamos ver como instalar no Ubuntu.

> **Quem está migrando de Docker Desktop para Docker Engine, temos duas opções**
>
> 1. Desinstalar o Docker Desktop.
> 2. Desativar o Docker Desktop Service nos serviços do Windows. Esta opção permite que você utilize o Docker Desktop, se necessário, para a maioria dos usuários a desinstalação do Docker Desktop é a mais recomendada. Se você escolheu a 2º opção, precisará excluir o arquivo ~/.docker/config.json e realizar a autenticação com Docker novamente através do comando "docker login"

> **Se necessitar integrar o Docker com outras IDEs que não sejam o VSCode**
>
> O VSCode já se integra com o Docker no WSL desta forma através da extensão Remote WSL ou Remote Container.
>
> É necessário habilitar a conexão ao servidor do Docker via TCP. Vamos aos passos:
>
> 1. Crie o arquivo /etc/docker/daemon.json: `sudo echo '{"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}' > /etc/docker/daemon.json`
> 2. Reinicie o Docker: `sudo service docker restart`
>
> Após este procedimento, vá na sua IDE e para conectar ao Docker escolha a opção TCP Socket e coloque a URL `http://IP-DO-WSL:2375`. Seu IP do WSL pode ser encontrado com o comando `cat /etc/resolv.conf`.
>
> Se caso não funcionar, reinicie o WSL com o comando `wsl --shutdown` e inicie o serviço do Docker novamente.

Execute os comandos:

```
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Adicione o repositório do Docker na lista de sources do Ubuntu:

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> OBSERVAÇÃO: Se você estiver usando uma distribuição diferente do Ubuntu, veja os comandos de instalação no documentação do Docker https://docs.docker.com/engine/install/

Dê permissão para rodar o Docker com seu usuário corrente:

```
sudo usermod -aG docker $USER
```

Reiniciar o WSL via linha de comando do Windows para que não seja necessário autorização root para rodar o comando docker:

```
wsl --shutdown
```

Acessar novamente o Ubuntu e iniciar o serviço do Docker:

```
sudo service docker start
```

Este comando acima terá que ser executado toda vez que o Linux for reiniciado. Se caso o serviço do Docker não estiver executando, mostrará esta mensagem de erro ao rodar comando `docker`:

```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

#### Erro ao iniciar o Docker no Ubuntu 22.04

> Se mesmo ao iniciar o serviço do Docker acontecer o seguinte erro ou similar:
>
> ```
> Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?` Rode o comando `sudo update-alternatives --config iptables` e escolha a opção 1 `iptables-legacy
> ```
>
> Rode novamente o `sudo service docker start`. Rode algum comando Docker como `docker ps` para verificar se está funcionando corretamente. Se não mostrar o erro acima, está ok.

#### Iniciar o Docker automaticamente no WSL

> **Apenas para Windows 11 ou Windows 10 com o update KB5020030**

É possível especificar um comando padrão para ser executados sempre que o WSL for iniciado, isto permite que já coloquemos o serviço do docker para iniciar automaticamente. Edite o arquivo `/etc/wsl.conf`:

Rode o comando para editar:

```conf
sudo vim /etc/wsl.conf
```

Aperte a letra `i` (para entrar no modo de inserção de conteúdo) e cole o conteúdo:

```conf
[boot]
command = service docker start
```

#### Docker com Systemd

Caso tenha ativado o systemd, na maioria dos casos o Docker iniciará automaticamente, portanto se você se tem a linha `command = service docker start` no `/etc/wsl.conf`, comente-a com `#` e reinicie o WSL com o comando `wsl --shutdown`.

Caso contrário, você pode inicia-lo automaticamente usando os comandos:

```
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

É necessário reiniciar o WSL com o comando `wsl --shutdown` para que as mudanças tenham efeito.

Pronto, basta reiniciar o WSL com o comando `wsl --shutdown` no DOS ou PowerShell para testar. Após abrir o WSL novamente, digite o comando `docker ps` para avaliar se o comando não retorna a mensagem acima: `Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?`
