# 🧩 Ollama + OpenClaw — imagem própria com GPU

Abordagem alternativa ao lab [`ollama-openclaw-stack`](../ollama-openclaw-stack): em vez de dois
contêineres, uma **imagem customizada** que parte do `ollama/ollama` e instala o agente OpenClaw na
mesma imagem, com **reserva de GPU NVIDIA** declarada no Compose.

## 🧱 Composição

| Arquivo | Conteúdo |
|---|---|
| `Dockerfile` | Base `ollama/ollama:latest` + instalação do OpenClaw via script oficial |
| `compose.yml` | Build local, portas `11434`, `18789` e `3000`, volume persistente e reserva de todas as GPUs |

## ✅ Pré-requisitos

- Docker Engine e Docker Compose v2
- Drivers NVIDIA e `nvidia-container-toolkit`

## ▶️ Como executar

```bash
cd ai-agents/ollama-openclaw-gpu

docker compose build
docker compose up -d

# verificar se a GPU foi reconhecida dentro do contêiner
docker exec -it ollama nvidia-smi

docker exec -it ollama ollama pull llama3
```

## 🧠 O que este lab demonstra

- Construção de **imagem derivada**, estendendo uma imagem oficial com ferramentas adicionais
- `build:` local no Compose em vez de imagem publicada
- Passagem de GPU para o contêiner (`driver: nvidia`, `count: all`, `capabilities: [gpu]`)
- Trade-off consciente entre **imagem única** (menos rede, mais acoplamento) e **serviços separados**

## 🔭 Evoluções previstas

- Fixar a versão do OpenClaw instalado em vez de usar o script `latest`
- Reduzir camadas e limpar o cache do apt no build
- Publicar a imagem em um registry e comparar o tempo de subida com a stack de dois serviços
