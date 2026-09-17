# 🧠 Ollama + OpenClaw — stack em serviços separados

Stack de agente de IA com **serviços desacoplados**: o Ollama como servidor de modelos e o OpenClaw
como camada de agente/interface, cada um em seu contêiner, com volumes nomeados e rede bridge própria.

## 🧱 Serviços

| Serviço | Imagem | Portas | Função |
|---|---|---|---|
| `Ollama` | `ollama/ollama:latest` | `11434` | Servidor de inferência |
| `OpenClaw` | `alpine/openclaw` | `18789`, `3000` | Agente de IA / interface |

A stack mantém também a definição comentada de um serviço **Open WebUI** (variante CUDA), usada
durante os testes de interface gráfica para o Ollama.

## ✅ Pré-requisitos

- Docker Engine e Docker Compose v2

## ▶️ Como executar

```bash
cd ai-agents/ollama-openclaw-stack

docker compose up -d
docker compose ps

docker exec -it Ollama ollama pull llama3

# Ollama    → http://localhost:11434
# OpenClaw  → http://localhost:3000
```

## 🧠 O que este lab demonstra

- Separação de responsabilidades entre **servidor de modelos** e **agente**
- Uso de volumes nomeados e rede `bridge` dedicada
- Política de reinício (`restart: always`) para serviços de longa duração
- Comparação direta com a abordagem de imagem única em [`ollama-openclaw-gpu`](../ollama-openclaw-gpu)

## 🔭 Evoluções previstas

- Reativar o Open WebUI como interface padrão
- Ajustar os mapeamentos de volume para caminhos independentes da máquina de origem
- Healthcheck no serviço do Ollama
