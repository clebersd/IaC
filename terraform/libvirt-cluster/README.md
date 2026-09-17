# 🏗️ Cluster de VMs Debian com Terraform + libvirt

Provisionamento declarativo de um pequeno cluster de laboratório: **4 máquinas virtuais Debian 13
(Trixie)** criadas em KVM/QEMU através do provider [`dmacvicar/libvirt`](https://registry.terraform.io/providers/dmacvicar/libvirt/latest),
com storage pool próprio, rede virtual dedicada e inicialização por **cloud-init**.

## 🧱 O que é criado

| Recurso | Descrição |
|---|---|
| `libvirt_pool.storage` | Pool de storage do laboratório |
| `libvirt_volume.debian` | Imagem base Debian 13 cloud (`.qcow2`) baixada do repositório oficial |
| `libvirt_volume.host0..3` | Discos das 4 VMs, derivados da imagem base |
| `libvirt_cloudinit_disk.commoninit` | ISO de cloud-init com usuário e senha inicial |
| `libvirt_network.inet` | Rede virtual dedicada às VMs |
| `libvirt_domain.host0..3` | 4 domínios com 2 vCPU e 1 GB de RAM cada |

## 📁 Estrutura

```text
libvirt-cluster/
├── main.tf               # Providers, backend do libvirt e chamada do módulo
├── variables.tf          # Variáveis da raiz (storage, imagem base, hostname)
├── terraform.tfvars      # Valores do ambiente local
├── cloud_init.cfg        # Configuração cloud-init das VMs
├── cloud_init_meta.cfg   # Metadados (instance-id / hostname)
└── hosts/                # Módulo com os recursos de pool, volumes, rede e domínios
    ├── variables.tf
    └── vms_libvirt.tf
```

## ✅ Pré-requisitos

- Terraform >= 1.5
- KVM/QEMU e libvirt ativos (`systemctl status libvirtd`)
- Usuário com permissão em `qemu:///system`
- Espaço em disco no caminho definido na variável `storage`

## ▶️ Como executar

```bash
cd terraform/libvirt-cluster

terraform init      # baixa o provider libvirt 0.8.3
terraform fmt       # formatação
terraform validate  # validação da configuração
terraform plan
terraform apply

# verificação
virsh list --all

# destruição do laboratório
terraform destroy
```

## 🧠 O que este lab demonstra

- Separação entre **raiz** e **módulo** (`./hosts`) com passagem de variáveis
- Uso de **imagem cloud oficial** em vez de instalação manual do SO
- **cloud-init** para bootstrap das VMs (hostname e acesso inicial)
- Ciclo de vida completo da infraestrutura versionado em código (`plan` → `apply` → `destroy`)
- Base reaproveitável para os labs de Ansible deste repositório

## ⚠️ Notas de laboratório

- As credenciais em `cloud_init.cfg` são de **laboratório local e isolado**; em ambiente real o acesso
  seria feito apenas por chave SSH injetada via cloud-init, sem senha.
- A variável `storage` aponta para um caminho local — ajuste antes de executar na sua máquina.

## 🔭 Evoluções previstas

- Substituir os quatro blocos de host por `for_each` sobre um `map` de VMs
- Extrair o módulo para `modules/vm` com `outputs` de IP
- Gerar automaticamente o inventário do Ansible a partir dos outputs
