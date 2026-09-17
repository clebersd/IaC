# 🐳 Stack LAMP em imagem própria

Imagem Docker construída a partir do **Debian Trixie** contendo um ambiente LAMP completo:
**Apache + MariaDB + PHP + phpMyAdmin**, com instalação totalmente não interativa.

## 🧱 Composição da imagem

| Camada | Detalhe |
|---|---|
| Base | `debian:trixie-backports` |
| Serviços | Apache2, MariaDB Server, PHP + `php-mysql`, phpMyAdmin |
| Volume | `/home/lamp` — persistência dos dados de trabalho |
| Portas | `80` (HTTP) e `3306` (MySQL) |
| Entrypoint | `script.sh` — sobe o Apache e o `mysqld_safe` |

## ✅ Pré-requisitos

- Docker Engine

## ▶️ Como executar

```bash
cd docker/lamp-stack

docker build -t lamp-lab .
docker run -d --name lamp -p 8080:80 -p 3306:3306 lamp-lab

# acesso
# http://localhost:8080
# http://localhost:8080/phpmyadmin

docker logs -f lamp
```

## 🧠 O que este lab demonstra

- Construção de imagem com **instalação não interativa** (`DEBIAN_FRONTEND` e
  `debconf-set-selections` para pré-responder o instalador do phpMyAdmin)
- Uso consciente de camadas, `ENV`, `WORKDIR`, `VOLUME` e `EXPOSE`
- Entrypoint customizado para orquestrar mais de um serviço dentro do contêiner
- Empacotamento de um stack clássico de infraestrutura em um artefato reproduzível

## ⚠️ Notas de laboratório

- A senha de root do MySQL definida na imagem é um **valor de exemplo de laboratório**; em uso real
  seria injetada em tempo de execução (`--env-file`, *secrets* ou variável de ambiente).
- Rodar Apache e MariaDB no mesmo contêiner é proposital neste lab (empacotar um LAMP "clássico").
  O caminho recomendado em produção é separar os serviços — evolução prevista abaixo.

## 🔭 Evoluções previstas

- Separar Apache/PHP e MariaDB em serviços distintos via Docker Compose
- Parametrizar credenciais por `.env` e remover valores fixos
- Build multi-stage e imagem final enxuta
