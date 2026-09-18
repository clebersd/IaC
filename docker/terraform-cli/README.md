# 🧰 Terraform CLI em imagem própria (multi-stage)

Empacotamento do **Terraform** em uma imagem enxuta e com versão fixada, usando **multi-stage build**:
um estágio baseado em Debian baixa e prepara o binário; a imagem final, baseada em **Alpine**, recebe
apenas o executável — sem `wget`, sem `unzip`, sem cache de pacotes e sem o arquivo `.zip` original.

O resultado é um Terraform portátil: qualquer máquina com Docker executa exatamente a mesma versão da
ferramenta, sem instalar nada no host e sem depender de binário versionado no repositório.

## 🧱 Composição da imagem

| Estágio | Base | Papel |
|---|---|---|
| `stage-one` | `debian:trixie` | Instala `wget`, `unzip` e `ca-certificates`, baixa o release oficial do HashiCorp, descompacta, ajusta permissão e limpa o `.zip` e o cache do apt |
| final | `alpine:3.23.5` | Recebe via `COPY --from` somente `/terra/terraform` |

| Diretiva | Valor | Efeito |
|---|---|---|
| `ARG APP` | versão do Terraform | Define qual release é baixado — passada no `docker build` |
| `ENTRYPOINT` | `/terra/terraform` | A imagem *é* o comando `terraform` |
| `CMD` | `init` | Subcomando padrão quando nenhum é informado |

A combinação `ENTRYPOINT` + `CMD` é o padrão correto para imagens de ferramenta: o contêiner se
comporta como o próprio executável e o subcomando vem como argumento do `docker run`.

## ✅ Pré-requisitos

- Docker Engine com BuildKit
- Acesso à internet durante o build (o binário é baixado de `releases.hashicorp.com`)

## ▶️ Como executar

```bash
cd docker/terraform-cli

# build — a versão do Terraform é escolhida aqui
docker build --build-arg APP=1.9.8 -t terraform-cli:1.9.8 .

# versão (sobrescreve o CMD padrão)
docker run --rm terraform-cli:1.9.8 version

# usando em um projeto real: monta o diretório atual dentro do contêiner
docker run --rm -v "$PWD":/work -w /work terraform-cli:1.9.8 init
docker run --rm -v "$PWD":/work -w /work terraform-cli:1.9.8 plan

# tamanho da imagem final
docker images terraform-cli
```

Aplicado ao laboratório de Terraform deste repositório:

```bash
cd terraform/libvirt-cluster
docker run --rm -v "$PWD":/work -w /work terraform-cli:1.9.8 validate
```

Manter a tag da imagem igual à versão do Terraform (`terraform-cli:1.9.8`) permite conviver com
várias versões da ferramenta na mesma máquina — útil ao migrar um projeto entre versões.

## 🧠 O que este lab demonstra

- **Multi-stage build**: o ambiente de preparação (Debian com `wget` e `unzip`) fica fora do artefato
  entregue; só o binário atravessa para a imagem final
- **Build reproduzível**: nada é copiado da máquina de quem constrói — o release oficial é baixado
  durante o build, e a versão fica explícita e parametrizável via `ARG`
- **Enxugamento de camadas**: `--no-install-recommends`, remoção do `.zip` e limpeza de
  `/var/lib/apt/lists/*` no mesmo `RUN`, evitando que os arquivos sobrevivam em camadas anteriores
- Escolha consciente da base final (**Alpine**) para reduzir tamanho e superfície de ataque
- Padrão `ENTRYPOINT` + `CMD` para transformar uma imagem em um comando
- **Versionamento da ferramenta**: o time inteiro roda a mesma versão, eliminando o clássico
  "na minha máquina funciona"

## ⚠️ Notas de laboratório

- Os `ca-certificates` são instalados no estágio de build, mas **não são copiados para a imagem
  final**. Comandos que apenas leem arquivos locais (`version`, `fmt`, `validate`) funcionam; já o
  `init` precisa de TLS para baixar providers e falha sem os certificados na imagem final. Correção
  na lista de evoluções.
- `ARG APP` não tem valor padrão: o build precisa receber `--build-arg APP=<versão>`, caso contrário
  a URL de download fica incompleta.
- O Terraform é distribuído como binário Go estático, por isso roda sobre a musl do Alpine sem
  necessidade de camada de compatibilidade glibc.

## 🔭 Evoluções previstas

- Adicionar `RUN apk add --no-cache ca-certificates` na imagem final para habilitar `init`, `plan` e `apply`
- Definir um valor padrão em `ARG APP` e validar a versão recebida
- Verificar a integridade do download com o `SHA256SUMS` oficial antes de descompactar
- Substituir o `chmod` por `COPY --from=stage-one --chmod=0755`
- Build multi-arquitetura (`linux/amd64` e `linux/arm64`) com `docker buildx`
- Publicar a imagem em um registry e usá-la como *runner* de Terraform em pipeline de CI
