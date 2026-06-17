# DevOps Project 07 — AWS Monitoring Stack

Prometheus + Grafana + Alertmanager monitoring stack deployed on AWS EC2. Infrastructure provisioned with Terraform, configuration managed with Ansible.

## Architecture

```
Internet
    │
    ▼
┌─────────────────────────────────┐
│  VPC (10.0.0.0/16)              │
│  Subnet 10.0.1.0/24             │
│                                 │
│  ┌──────────────────────────┐   │
│  │  EC2 t3.micro (Ubuntu)   │   │
│  │                          │   │
│  │  ┌────────────────────┐  │   │
│  │  │  Docker Compose    │  │   │
│  │  │  ├── Prometheus    │  │   │
│  │  │  ├── Grafana       │  │   │
│  │  │  ├── Alertmanager  │  │   │
│  │  │  └── Node Exporter │  │   │
│  │  └────────────────────┘  │   │
│  └──────────────────────────┘   │
└─────────────────────────────────┘
```

## Stack

| Tool | Purpose |
|------|---------|
| Terraform | Provision AWS infrastructure (VPC, EC2, EIP, Security Groups) |
| Ansible | Configure EC2, install Docker, deploy monitoring stack |
| Prometheus | Metrics collection and storage |
| Grafana | Metrics visualization and dashboards |
| Alertmanager | Alert routing (Telegram notifications) |
| Node Exporter | System metrics (CPU, RAM, disk) |

## Ports

| Port | Service |
|------|---------|
| 22 | SSH |
| 3000 | Grafana |
| 9090 | Prometheus |

## Quick Start

**Prerequisites:** AWS credentials, Terraform, Ansible

```bash
# 1. Provision infrastructure
cd terraform/
terraform init
terraform apply
# outputs EC2 public IP and generates ansible/inventory.ini automatically

# 2. Deploy monitoring stack
cd ../ansible/
ansible-playbook -i inventory.ini playbook.yml
```

## Access

After deployment:
- Grafana: `http://<ec2-ip>:3000` (admin / admin)
- Prometheus: `http://<ec2-ip>:9090`

## Terraform Modules

```
terraform/modules/
├── vpc/              # VPC, subnet, IGW, route table
├── security-groups/  # SSH, HTTP, Grafana, Prometheus ports
└── ec2/              # EC2 instance, EIP, key pair
```

## Cost

EC2 t3.micro ~$0.01/hour. Run `terraform destroy` when not in use.
