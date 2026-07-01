# DevOps Monitoring Stack

Full observability stack running on a single AWS EC2 instance. Terraform provisions the infrastructure; Ansible installs Docker and deploys the monitoring stack via Docker Compose. Includes Telegram alerting via Alertmanager.

## Stack

```
EC2 (t3.micro)
  └── Docker Compose
        ├── Prometheus      :9090  — metrics collection & storage
        ├── Grafana         :3000  — dashboards & visualization
        ├── Alertmanager    :9093  — alert routing → Telegram
        └── Node Exporter   :9100  — host metrics (CPU, RAM, disk, net)
```

## Tech Stack

- **IaC:** Terraform
- **Configuration Management:** Ansible (2 roles)
- **Containerization:** Docker, Docker Compose
- **Monitoring:** Prometheus, Grafana, Alertmanager, Node Exporter
- **Alerting:** Telegram Bot

## Project Structure

```
terraform/
  modules/
    vpc/              # VPC, public subnet, IGW, route table
    security-groups/  # Inbound: 22, 3000 (Grafana), 9090 (Prometheus), 9093 (Alertmanager)
    ec2/              # EC2 t3.micro, Elastic IP, key pair
  outputs.tf          # Outputs EC2 IP → auto-writes ansible/inventory.ini

ansible/
  playbook.yml        # Applies: docker role + monitoring role
  roles/
    docker/           # Installs Docker + Docker Compose on EC2
    monitoring/       # Deploys the Docker Compose stack
  group_vars/         # Telegram bot token, chat ID
```

## Deploy

**Prerequisites:** AWS credentials, Terraform, Ansible

```bash
# 1. Provision EC2
cd terraform/
terraform init
terraform apply
# inventory.ini is auto-generated in ansible/

# 2. Configure and deploy monitoring
cd ../ansible/
# Set Telegram bot token and chat ID in group_vars/
ansible-playbook playbook.yml
```

## Access

| Service | URL |
|---------|-----|
| Grafana | `http://<EC2-IP>:3000` (admin/admin on first login) |
| Prometheus | `http://<EC2-IP>:9090` |
| Alertmanager | `http://<EC2-IP>:9093` |

## Key Concepts

- **Terraform output → Ansible inventory** — no manual copy-paste of IPs between tools
- **Two Ansible roles** — clean separation between Docker installation and monitoring config
- **Alertmanager → Telegram** — alerts go to a Telegram channel instead of email
