# DevOps Assessment

## Overview

This repository contains the solution for the DevOps Assessment.

### Technology Stack

- Terraform
- AWS (Infrastructure as Code)
- Docker Compose
- PostgreSQL
- Shell Scripting
- GitHub Actions (Optional)

## Project Structure

```
infra/
├── modules/
├── envs/
│   ├── dev/
│   └── prod/

db/
├── migrations/
├── seed/

scripts/
```

Further setup and execution instructions will be added as the implementation progresses.

## Query Optimization

Created composite index:

(city, created_at, org_id, status)

The index supports filtering by city and created_at and improves grouping operations by org_id and status.

For the local dataset (100 rows), PostgreSQL chooses Sequential Scan because scanning the entire table is cheaper than using an index.

For large production datasets, the composite index reduces full table scans and improves query performance.

## Database Setup

cd db
docker compose up -d


## Migration

docker exec ...


## Backup

./scripts/backup.sh


## Restore Verification

./scripts/restore.sh backup.sql


## Index Explanation

Created composite index:

(city, created_at, org_id, status)

because query filters by city and created_at.