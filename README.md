# DevOps Assessment – Terraform + Database Reliability

## Overview

This repository contains a solution for the DevOps Assessment covering Terraform infrastructure design and PostgreSQL database reliability tasks.

The project demonstrates:

- AWS infrastructure design using Terraform
- Multi-environment Terraform structure (dev & prod)
- Local PostgreSQL using Docker Compose
- Database schema migrations
- Seed data generation
- Query optimization using indexes
- Database backup and restore automation
- Version control using Git

---

# Technology Stack

- Terraform
- AWS
- Docker Compose
- PostgreSQL
- Shell Scripting
- Git
- GitHub

---

# Project Structure

```
.
├── infra
│   ├── envs
│   │   ├── dev
│   │   └── prod
│   └── modules
│       ├── network
│       ├── ecs
│       └── rds
│
├── db
│   ├── migrations
│   │   ├── 01_schema.sql
│   │   └── 02_indexes.sql
│   ├── seed
│   │   ├── seed.sql
│   │   └── events.sql
│   └── docker-compose.yml
│
├── scripts
│   ├── backup.sh
│   └── restore.sh
│
└── README.md
```

---

# Terraform Infrastructure

The infrastructure is designed as:

```
Internet
    |
Application Load Balancer
    |
ECS / Fargate
    |
Amazon RDS PostgreSQL
```

Terraform modules include:

- Network
- ECS
- RDS

Separate environments are available for:

- dev
- prod

Environment specific configuration includes:

- Variables
- tfvars
- Backend configuration
- Resource sizing
- Backup retention
- Deletion protection

---

# Terraform Verification

From the project root:

```bash
terraform fmt -recursive
```

For the development environment:

```bash
cd infra/envs/dev

terraform init

terraform validate

terraform plan -refresh=false
```

**Note**

AWS deployment is not required for this assessment.

Terraform code has been written for production-style infrastructure. Running `terraform plan` requires valid AWS credentials.

---

# Database Setup

Start PostgreSQL locally.

```bash
cd db

docker compose up -d
```

Verify the container:

```bash
docker ps
```

---

# Database Migration

Create the database schema.

```bash
cd db

docker exec -i hotel_db psql -U admin -d hotel < migrations/01_schema.sql
```

Create indexes.

```bash
docker exec -i hotel_db psql -U admin -d hotel < migrations/02_indexes.sql
```

---

# Seed Data

Insert booking data.

```bash
docker exec -i hotel_db psql -U admin -d hotel < seed/seed.sql
```

Insert booking events.

```bash
docker exec -i hotel_db psql -U admin -d hotel < seed/events.sql
```

The seed data contains:

- 100 hotel bookings
- Multiple organizations
- Multiple cities
- Multiple booking statuses
- Booking events

---

# Query Optimization

The required query is:

```sql
SELECT org_id,
       status,
       COUNT(*),
       SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

A composite index was created:

```sql
(city, created_at, org_id, status)
```

This index improves filtering by:

- city
- created_at

and helps PostgreSQL efficiently group data by:

- org_id
- status

For the sample dataset (100 rows), PostgreSQL may still choose a Sequential Scan because scanning a small table is cheaper than using an index.

For production-scale datasets, the composite index significantly reduces full table scans and improves query performance.

---

# Database Backup

Create a timestamped backup.

```bash
./scripts/backup.sh
```

Example output:

```
backups/hotel_db_YYYYMMDD_HHMMSS.sql
```

---

# Database Restore

Restore a backup into a fresh database.

```bash
./scripts/restore.sh backups/<backup_file>.sql
```

---

# Restore Verification

Connect to the restored database.

```bash
docker exec -it hotel_db psql -U admin -d hotel_restore
```

Verify tables.

```sql
\dt
```

Verify booking count.

```sql
SELECT COUNT(*) FROM hotel_bookings;
```

Expected:

```
100
```

Verify booking events.

```sql
SELECT COUNT(*) FROM booking_events;
```

Expected:

```
100
```

---

# Assignment Checklist

- Terraform Network Module
- Terraform ECS Module
- Terraform RDS Module
- Separate Dev Environment
- Separate Prod Environment
- Docker Compose
- PostgreSQL Database
- Database Migrations
- Seed Data
- Query Optimization
- Backup Script
- Restore Script
- README Documentation

---

# GitHub Repository

The complete solution has been committed and pushed to GitHub as required by the assessment.