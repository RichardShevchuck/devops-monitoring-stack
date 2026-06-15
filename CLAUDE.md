# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Monitoring stack on AWS — Terraform provisions the infrastructure, Ansible (not yet implemented) will configure it. Ports 3000 (Grafana) and 9090 (Prometheus) are open in the security group, indicating the planned monitoring toolset.

## Terraform Commands

All commands run from the `terraform/` directory.

```bash
cd terraform

terraform init          # initialize providers and modules
terraform validate      # check config syntax
terraform plan          # preview changes
terraform apply         # provision infrastructure
terraform destroy       # tear down all resources
```

Plan to file (safer apply flow):
```bash
terraform plan -out=tfplan
terraform apply tfplan
```

## Architecture

Root module (`terraform/main.tf`) wires three child modules together — no variables or outputs are defined at root level yet.

**Module dependency chain:**
```
vpc → security-groups (needs vpc_id)
vpc → ec2 (needs subnet_id)
security-groups → ec2 (needs web_sg_id)
```

**`modules/vpc`** — creates the full network stack:
- VPC: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24` in `eu-central-1a` with `map_public_ip_on_launch = true`
- Internet gateway + route table wired to the subnet

**`modules/security-groups`** — single security group `web-sg` allowing inbound: 22 (SSH), 80 (HTTP), 3000 (Grafana), 9090 (Prometheus) from `0.0.0.0/0`

**`modules/ec2`** — single `t3.micro` Ubuntu 20.04 LTS instance (Canonical AMI, most recent) placed in the public subnet with the web-sg attached. Key pair name defaults to `~/.ssh/id_rsa.pub` (likely needs correction to just the key pair name, not path).

## AWS Configuration

- Region: `eu-central-1`
- AWS credentials must be configured via environment variables or `~/.aws/credentials` before running Terraform
- `.tfvars` files are gitignored — use them for sensitive or environment-specific values

## Ansible

`ansible/` directory exists but is empty — provisioning/configuration layer not yet implemented.
