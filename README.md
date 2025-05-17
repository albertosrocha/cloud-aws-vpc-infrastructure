**🇧🇷 Português** | [🇺🇸 English](./README-en.md)

# Infraestrutura AWS VPC com Terraform

Esta configuração do Terraform provisiona uma infraestrutura completa de rede VPC na AWS, incluindo sub-redes públicas e privadas, NAT Gateway, Internet Gateway, tabelas de rotas e endpoints VPC para S3 e DynamoDB.

## Funcionalidades

- **VPC** com bloco CIDR configurável, suporte a DNS e hostnames DNS.
- **Sub-redes públicas e privadas** distribuídas em múltiplas Zonas de Disponibilidade.
- **Internet Gateway** para acesso à internet das sub-redes públicas.
- **NAT Gateway** com Elastic IP para acesso à internet das sub-redes privadas.
- **Tabelas de Rotas** para roteamento público e privado.
- **VPC Endpoints** para S3 e DynamoDB, permitindo conectividade privada.
- **Tagueamento** de todos os recursos com metadados de ambiente e repositório.

**Multi-Account**: Permite o provisionamento de várias contas AWS, geralmente utilizado para segmentar ambientes como desenvolvimento, homologação e produção.

## Variáveis
Certifique-se de definir as seguintes variáveis no arquivo `infra/envs/<env>/<env>-parameters.tfvars`.:

| Variável                 | Descrição                                              | Exemplo                            |
|--------------------------|--------------------------------------------------------|------------------------------------|
| `vpc_cidr`               | CIDR block da VPC                                      | `"10.0.0.0/16"`                    |
| `enable_dns_hostnames`   | Habilita ou não DNS hostnames                          | `true`                             |
| `enable_dns_support`     | Habilita ou não suporte a DNS                          | `true`                             |
| `environment`            | Nome do ambiente (ex: dev, staging, prod)             | `"dev"`                            |
| `repo_url`  (opcional)             | URL do repositório de código                          | `"https://github.com/org/repo"`    |
| `aws_region`             | Região da AWS                                          | `"us-east-1"`                      |
| `availability_zones`     | Lista de zonas de disponibilidade                      | `["us-east-1a", "us-east-1b"]`     |
| `private_subnets_cidrs`  | Lista de CIDRs para sub-redes privadas                 | `["10.0.1.0/24", "10.0.2.0/24"]`   |
| `public_subnets_cidrs`   | Lista de CIDRs para sub-redes públicas                 | `["10.0.101.0/24", "10.0.102.0/24"]`|


## Tags
Todos os recursos recebem as seguintes tags padrão:

- `Name`
- `cloud:environment`
- `cloud:resource:name`
- `cloud:resource:type`
- `code:repo-url`

## Observações
- O primeiro subnet público é usado para o NAT Gateway.
- O endpoint de VPC é criado para serviços essenciais (S3 e DynamoDB), permitindo acesso privado sem passar pela internet pública.
- As tabelas de roteamento são separadas por tipo de sub-rede, com rotas apropriadas. 

## Uso

1. **Credenciais AWS**

    Certifique-se de que suas credenciais AWS estejam configuradas antes de executar o Terraform.

1. **Configure as Variáveis**

    O arquivo `infra/envs/dev/dev-parameters.tfvars` está preenchido com um exemplo.
    
    Edite os valores das variáveis no arquivo `tfvars` apropriado em `infra/envs/<env>/<env>-parameters.tfvars`.

2. **Terraform**

   ```sh
   cd infra
   terraform init
   terraform plan -var-file=envs/dev/dev-parameters.tfvars -input=false -out=tf-plan-file
   terraform apply -auto-approve -input=false tf-plan-file
   ```

## 🗺️ Roadmap

Abaixo estão as etapas planejadas para a evolução deste projeto de infraestrutura. O objetivo é melhorar a automação, segurança e segregação de ambientes por meio de pipelines CI/CD e boas práticas com Terraform.

- ✅ Definir toda a estrutura de VPC com Terraform
- ✅ Parametrizar a configuração com arquivos `.tfvars` por ambiente
- 🔄 Configurar backend remoto para o estado do Terraform (ex: S3)
- 📝 Integrar **GitHub Actions** para CI/CD em ambientes de desenvolvimento e homologação
- 📝 Integrar **Bitbucket Pipelines** para CI/CD no ambiente de produção

> ✅ Concluído 🔄 Em andamento 📝 Planejado
