# 🤖 Agentes de IA e AIOps

Laboratórios de **IA aplicada a operações de TI**: automação de fluxos, agentes conversacionais,
RAG sobre bases próprias e execução de LLMs locais com GPU.

| Lab | Foco |
|---|---|
| [`n8n-rag-agent`](n8n-rag-agent) | Pipeline RAG completo: Google Drive → embeddings Mistral → Supabase Vector Store → agente com LLM Groq |
| [`n8n-ollama-chatbot`](n8n-ollama-chatbot) | Chatbot com LLM local acelerado por GPU |
| [`ollama-openclaw-stack`](ollama-openclaw-stack) | Ollama e OpenClaw como serviços separados |
| [`ollama-openclaw-gpu`](ollama-openclaw-gpu) | Mesma solução em imagem própria, com reserva de GPU |

**Por que este tema:** tickets, logs e documentação são a matéria-prima do dia a dia de infraestrutura.
Estes labs exploram como colocar LLMs — preferencialmente locais, sem envio de dados para fora —
para reduzir trabalho repetitivo nessa rotina.
