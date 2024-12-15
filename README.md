<h1 align="center">[GCSI] - Configuração do Load Balancer com Docker e Nginx para recursos da aplicação Front-end.</h1>

> ⚠️ AVISO: Todos os comandos utilizados neste repositório foram realizados em uma distribuição Linux Ubuntu.

Este guia descreve os passos para configurar um balanceador de carga (Load Balancer) para uma aplicação frontend utilizando NGINX em contêineres Docker.

<p>
  <a href="#passo1">Passo 1 – Compilar o Projeto Frontend</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#passo2">Passo 2 – Configuração do NGINX</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#passo3">Passo 3 – Subir os Contêineres com os Nodes</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#passo4">Passo 4 – Configuração do Load Balancer</a>&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;&nbsp;
  <a href="#teste">Testando a Configuração</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>

## Pré-requisitos
- Docker instalado
- Projeto frontend configurado
- NGINX configurado para atuar como servidor e balanceador de carga

## Passos

<div id='passo1'></div>

### 1. Compilar o Projeto Frontend

Execute os comandos abaixo no diretório raiz do projeto para instalar as dependências e compilar a aplicação:

```bash
npm i && npm run build
```

> O resultado será uma pasta `build` contendo os arquivos estáticos da aplicação.

<div id='passo2'></div>

### 2. Configuração do NGINX

#### Arquivo `nginx.conf`

Crie ou edite o arquivo `nginx.conf` com o seguinte conteúdo:
```nginx
user nginx;  # Define o usuário do sistema sob o qual o NGINX será executado
worker_processes auto;  # Configura automaticamente o número de processos de trabalho com base no hardware

events {
  worker_connections 1024;  # Define o número máximo de conexões simultâneas por processo de trabalho
}

http {
  include mime.types;  # Inclui definições de tipos MIME para reconhecimento de arquivos (ex.: HTML, CSS, JS)
  default_type application/octet-stream;  # Define o tipo de arquivo padrão caso não seja identificado pelo MIME
  include /etc/nginx/conf.d/*.conf;  # Carrega configurações adicionais do diretório especificado

  # Define o formato do log de acesso, incluindo detalhes como IP real, usuário remoto, horário, requisição, etc.
  log_format  main  '$http_x_real_ip - $remote_user [$time_local] "$request" '
      '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" "$http_x_forwarded_for"';

  access_log /var/log/nginx/nginx-access.log main;  # Especifica o arquivo onde os logs de acesso serão armazenados
}
```

Essencialmente, este arquivo configura o NGINX para servir arquivos com suporte básico a tipos MIME, gerenciar logs de acesso detalhados e permitir o uso de configurações adicionais para maior personalização.

#### Arquivo `default.conf`

Crie ou edite o arquivo `default.conf` com o seguinte conteúdo:
```nginx
# Definição de servidores upstream para balanceamento de carga
upstream nodes {
  # Definindo o endereço IP dos servidores backend
  server 172.17.0.2;  
  server 172.17.0.3;  
  server 172.17.0.4;  
  server 172.17.0.5; 
  server 172.17.0.6;  
}

server {
  listen 80;  # Porta onde o servidor NGINX ficará escutando conexões HTTP
  server_name localhost;  # Nome do servidor que responde às requisições

  location / {
    proxy_pass http://nodes;  # Encaminha requisições para os servidores definidos no bloco upstream
    proxy_set_header X-Real-IP $remote_addr;  # Adiciona o IP real do cliente no cabeçalho da requisição enviada ao backend
  }
}

```
Este arquivo de configuração define um servidor NGINX que atua como um **proxy reverso** para um grupo de servidores backend (chamados de nodes).
O NGINX recebe requisições do cliente na porta 80 e as encaminha para os servidores definidos no bloco `upstream`, atuando como um intermediário para **balanceamento de carga e controle**.

<div id='passo3'></div>

### 3. Subir os Contêineres com os Nodes

Utilize os comandos abaixo para criar os contêineres dos nodes que servirão os arquivos estáticos:
```bash
  docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node1 nginx:alpine
  docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node2 nginx:alpine
  docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node3 nginx:alpine
  docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node4 nginx:alpine
  docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node5 nginx:alpine
```

<div id='passo4'></div>

### 4. Configuração do Load Balancer

Para configurar o balanceador de carga, execute o comando abaixo:
```bash
docker run -d -p 80:80 \
  -v ./default.conf:/etc/nginx/conf.d/default.conf \
  --name loadbalancer --hostname loadbalancer nginx:alpine
```

Esse contêiner será responsável por distribuir o tráfego entre os nodes definidos no arquivo `default.conf`.

---

<div id='teste'></div>

## Testando a Configuração

Acesse o endereço `http://localhost` no navegador para verificar se o balanceador de carga está funcionando corretamente. O tráfego será distribuído automaticamente entre os nodes configurados.

veja o exemplo abaixo:

![localhost](assets/localhost.png)

---

## Observações
- Certifique-se de que os endereços IP dos nodes (`172.17.0.X`) estejam corretos e acessíveis pelo contêiner do balanceador de carga.
- Os logs de acesso podem ser verificados no arquivo `/var/log/nginx/nginx-access.log` dentro do contêiner do load balancer.

### Referências utilizadas:
- HTTP Load Balancing: https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/
- Nginx: do básico ao Load Balancer: https://youtu.be/pPlcC5hDMCs?feature=shared

## Aproveite este projeto!
Criado por **João Igor dos Santos Barbosa**.

[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/ignizxl)