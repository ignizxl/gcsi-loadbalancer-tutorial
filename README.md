<h1 align="center">[GCSI] - Configuração do Load Balancer com Docker e Nginx para recursos da aplicação Front-end.</h1>

> ⚠️ AVISO: Todos os comandos utilizados neste repositório foram realizados em uma distribuição Linux Ubuntu.

Este guia descreve os passos para configurar um balanceador de carga (Load Balancer) para uma aplicação frontend utilizando NGINX em contêineres Docker.

## Pré-requisitos
- Docker instalado
- Projeto frontend configurado
- NGINX configurado para atuar como servidor e balanceador de carga

## Passos

### 1. Compilar o Projeto Frontend

Execute os comandos abaixo no diretório raiz do projeto para instalar as dependências e compilar a aplicação:

```bash
npm i && npm run build
```

> O resultado será uma pasta `build` contendo os arquivos estáticos da aplicação.

