#!/bin/bash

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_DIR="backups"

BACKUP_FILE="${BACKUP_DIR}/hotel_db_${TIMESTAMP}.sql"

mkdir -p ${BACKUP_DIR}

echo "Starting PostgreSQL backup..."

docker exec hotel_db pg_dump \
    -U admin \
    -d hotel \
    > ${BACKUP_FILE}

echo "Backup completed successfully"
echo "Backup file: ${BACKUP_FILE}"