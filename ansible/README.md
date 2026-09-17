# ⚙️ Baseline de servidores Linux com Ansible

Configuração pós-provisionamento das VMs criadas no lab de [Terraform](../terraform/libvirt-cluster):
preparação do sistema, instalação do Docker e gestão de usuários e chaves SSH — de forma
**idempotente** e organizada em *roles*.

## 📁 Estrutura

```text
ansible/
├── ansible.cfg        # Configuração do projeto (inventário local em ./hosts)
├── hosts              # Inventário estático: grupo [infra] e grupos por host
├── playbook.yml       # Playbook principal, aplica as roles ao alvo
└── roles/
    ├── common/        # apt update, pacotes base, Docker e serviço ativo
    ├── docker/        # Gestão de containers e imagens no host remoto
    └── users/         # Criação/remoção de usuários e distribuição de chave SSH
```

## 🧩 Roles

| Role | Responsabilidade |
|---|---|
| `common` | Atualiza o cache do apt, instala pacotes base (`ca-certificates`, `curl`, `gnupg`, `docker.io`, `docker-compose`) e garante o serviço Docker iniciado |
| `users` | Cria usuários padrão com shell e home, remove contas obsoletas do sistema e publica a chave pública nos `authorized_keys` |
| `docker` | Opera recursos Docker no host remoto (containers e imagens) via módulos `community.docker` |

## ✅ Pré-requisitos

- Ansible >= 2.15 na estação de controle
- Acesso SSH por chave aos hosts do inventário
- Coleção `community.docker` (`ansible-galaxy collection install community.docker`)

## ▶️ Como executar

```bash
cd ansible

# conectividade com todos os hosts
ansible -i hosts infra -m ping

# execução simulada (dry-run)
ansible-playbook playbook.yml --check --diff

# aplicação
ansible-playbook playbook.yml

# aplicando apenas a um host
ansible-playbook playbook.yml --limit host1
```

O alvo e as roles ativas são definidos em `playbook.yml` — basta descomentar as roles desejadas.

## 🧠 O que este lab demonstra

- Organização em **roles** com separação entre `tasks` e `vars`
- **Idempotência**: reexecutar o playbook não altera o estado já convergido
- Gestão de identidade: criação de usuários, remoção de contas desnecessárias (**hardening**)
  e distribuição centralizada de chaves SSH
- Inventário com grupos lógicos (`infra`) e por host, permitindo execução segmentada
- Integração com o lab de Terraform: as VMs provisionadas são os alvos deste inventário

## ⚠️ Notas de laboratório

- O inventário usa endereços **privados** (`192.168.1.0/24`) da rede do laboratório.
- A senha em `roles/users` é um valor de exemplo passado por `password_hash('sha512')`; em produção
  seria armazenada em **Ansible Vault** ou injetada por variável de ambiente.

## 🔭 Evoluções previstas

- Migrar variáveis sensíveis para `ansible-vault`
- Adicionar `handlers` para reinício de serviços
- Inventário dinâmico gerado pelos outputs do Terraform
- `ansible-lint` em pipeline de CI
