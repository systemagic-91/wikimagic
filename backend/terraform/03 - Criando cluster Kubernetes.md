# Criando cluster Kubernetes

Kubernates (K8s) é uma ferramenta que gerencia aplicações que estão rodando em containers. Num contexto onde uma organização tem **centenas de containers** se torna necessário algo que possa cuidar deles: 

- iniciar containers
- parar containers
- reiniciar containers que deram problema
- distribuir containers entre servidores
- criar mais cópias quando há muito acesso (escalar)
- substituir containers que falharam
- fazer atualizações
- descobrir onde cada aplicação está rodando

Para isso podemos usar o kubernates. Ele é como um gerente dos containers. Podemos dizer: "quero que minha aplicação tenha 3 instancias rodando". O kubernates tenta manter esse estado e se algo acontecer e uma cópia falhar ele cria/substitui o que for necessário para voltar ao estado desejado.

O Terraform e o Kubernetes podem trabalhar juntos: **O Terraform pode criar a infra necessária para um cluster Kubernates, enquanto o Kubernates gerencia as aplicações que rodam dentro desse cluster.**

### Conceitos de VPC na AWS

