# 🎫 GLPI Service Desk com automação e IA

Stack multi-serviço que sobe um ambiente completo de **service desk** (GLPI + MySQL + phpMyAdmin) já
integrado a uma camada de **automação e IA** (n8n + Ollama) na mesma rede Docker — a base para
experimentos de **AIOps** sobre chamados: triagem, classificação e sugestão de resposta.

## 🧱 Serviços

| Serviço | Imagem | Porta | Função |
|---|---|---|---|
| `glpi-prod-server` | `glpi/glpi:latest` | `80` | Service desk / ITSM |
| `mysql-prod-server` | `mysql:latest` | interna | Banco de dados do GLPI |
| `phpmyadmin-prod` | `phpmyadmin` | `8080` | Administração do banco |
| `n8n-prod` | n8n | `5678` | Automação de workflows sobre os chamados |
| `Ollama-prod` | Ollama | `11434` | LLM local com reserva de GPU NVIDIA |

Todos os serviços compartilham a rede `glpi` e usam **volumes nomeados** (`http_glpi`, `mysql_glpi`,
`n8n_glpi`) para persistência.

## ✅ Pré-requisitos

- Docker Engine e Docker Compose v2
- Para o serviço Ollama: drivers NVIDIA e `nvidia-container-toolkit`

## ▶️ Como executar

```bash
cd docker/glpi-servicedesk

docker compose config      # valida o arquivo antes de subir
docker compose up -d
docker compose ps
docker compose logs -f glpi_prod

# acesso
# GLPI        → http://localhost
# phpMyAdmin  → http://localhost:8080
# n8n         → http://localhost:5678

docker compose down          # parar
docker compose down -v       # parar e remover os volumes
```

## 🧠 O que este lab demonstra

- Orquestração de um stack **multi-serviço** com dependências (`depends_on`), rede dedicada e
  persistência por volumes nomeados
- Provisionamento de uma ferramenta real de **ITSM** (GLPI) em contêiner
- Integração entre infraestrutura tradicional de suporte e **agentes de IA locais**
- Alocação de **GPU** para inferência via `deploy.resources.reservations.devices`

## ⚠️ Notas de laboratório

- As senhas do MySQL/phpMyAdmin são **valores iniciais de laboratório**, marcados no próprio arquivo
  para troca posterior. Em ambiente real seriam lidas de um `.env` fora do versionamento ou de um
  cofre de segredos.
- O stack expõe a porta `80` diretamente — em produção entraria atrás de um proxy reverso com TLS.

## 🔭 Evoluções previstas

- Externalizar credenciais em `.env` / Docker secrets
- Proxy reverso (Traefik ou Nginx) com HTTPS
- `healthcheck` por serviço e rotina de backup do volume do MySQL
- Workflow n8n de triagem automática de chamados do GLPI
