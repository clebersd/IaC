# 💬 Chatbot com n8n + Ollama local

Ambiente mínimo para prototipar chatbots e automações conversacionais com **LLM rodando localmente**,
sem depender de API externa: o n8n orquestra os fluxos e o Ollama executa o modelo com aceleração
por **GPU NVIDIA**.

## 🧱 Serviços

| Serviço | Imagem | Porta | Função |
|---|---|---|---|
| `01` | `n8nio/n8n` | `5678` | Orquestração dos fluxos conversacionais |
| `02` | `ollama/ollama:latest` | `11434` | Servidor de inferência local (GPU) |

## ✅ Pré-requisitos

- Docker Engine e Docker Compose v2
- Drivers NVIDIA e `nvidia-container-toolkit` instalados no host

## ▶️ Como executar

```bash
cd ai-agents/n8n-ollama-chatbot

docker compose up -d

# baixar um modelo para uso local
docker exec -it 02 ollama pull llama3

# testar a API de inferência
curl http://localhost:11434/api/tags

# n8n → http://localhost:5678
```

No n8n, aponte o nó de LLM para `http://02:11434` (nome do serviço na rede do Compose).

## 🧠 O que este lab demonstra

- Inferência de LLM **on-premise**, com dados que não saem do ambiente
- Reserva explícita de GPU no Compose (`deploy.resources.reservations.devices`)
- Integração entre uma ferramenta de automação e um servidor de modelos local

## 🔭 Evoluções previstas

- Nomes de contêiner descritivos e volumes persistentes para os modelos
- Interface de chat (Open WebUI) na frente do Ollama
- Comparativo de latência e consumo entre modelos locais
