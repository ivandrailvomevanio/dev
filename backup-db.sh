#!/bin/bash
#
# Carrega as variáveis de ambiente
export $(grep -v '^#' .env | xargs)

# CONFIGURAÇÕES
DB_NAME="$MYSQL_DATABASE"
DB_USER="$MYSQL_USER"
DB_PASS="$MYSQL_PASSWORD"
BACKUP_DIR="./backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Garante que a pasta exista
mkdir -p "$BACKUP_DIR"

# Executa o backup diretamente no host (ajuste a porta se necessário)
mysqldump -h 127.0.0.1 -P 3306 -u$DB_USER -p$DB_PASS $DB_NAME \
	    > "$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"

# Remove backups antigos (exemplo: mais de 7 dias)
find "$BACKUP_DIR" -type f -name "${DB_NAME}_backup_*.sql" -mtime +7 -exec rm {} \;

echo "Backup finalizado: $BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"
