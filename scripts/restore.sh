#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: ./restore.sh <backup_file>"
    exit 1
fi

BACKUP_FILE=$1

echo "Creating fresh restore database..."

docker exec hotel_db psql \
    -U admin \
    -d hotel \
    -c "DROP DATABASE IF EXISTS hotel_restore;"

docker exec hotel_db psql \
    -U admin \
    -d hotel \
    -c "CREATE DATABASE hotel_restore;"

echo "Restoring backup..."

cat ${BACKUP_FILE} | docker exec -i hotel_db psql \
    -U admin \
    -d hotel_restore

echo "Restore completed successfully"