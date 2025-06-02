# Projeto Docker: Apache + PHP-FPM + MariaDB

Este projeto configura um ambiente completo com Apache, PHP-FPM (FastCGI) e MariaDB usando Docker Compose. Ele foi desenvolvido como um ambiente de demonstração funcional e modular para aplicações PHP com banco de dados.

## Serviços

- **Apache**: Servidor web, configurado para encaminhar requisições PHP para o PHP-FPM via FastCGI.
- **PHP-FPM**: Interpretador PHP rodando em processo separado.
- **MariaDB**: Banco de dados relacional MySQL-compatible.
- **Volume persistente** para dados do banco.
- **Rede Docker customizada** para comunicação entre os containers.

---

## Estrutura de Diretórios
dev/
├── apache
│ └── httpd.conf # Configuração personalizada do Apache
├── html
│ └── index.php # Código PHP de teste (phpinfo)
├── .env # Variáveis de ambiente sensíveis
└── docker-compose.yml # Definição dos containers


---

## Observações sobre o arquivo php.ini

Este projeto **não inclui um arquivo `php.ini` customizado** — o PHP-FPM utiliza as configurações padrão do container oficial `php:8.2-fpm`.

Caso deseje adicionar um `php.ini` para customizar o comportamento do PHP, recomendamos:

- Usar um arquivo simples, com configurações genéricas (exemplo: timezone, limites de upload, nível de erros)
- Não incluir informações sensíveis ou específicas do ambiente (senhas, paths privados)
- Evitar expor este arquivo publicamente em repositórios públicos, a não ser que seja para demonstração, sem dados confidenciais

Como este projeto é apenas para demonstração, o arquivo `php.ini` não está incluído para manter o exemplo mais limpo e simples.


## Pré-requisitos

- Docker
- Docker Compose
- Git (para clonar o projeto)

---

## Criação da rede personalizada

Antes de subir os containers, **é necessário criar a rede `proxy-reverso` manualmente**, pois ela é externa ao `docker-compose.yml`.
Abaixo, coloquei um exemplo, de como fiz aqui no laboratório, pois a ideia foi colocar os containers na mesma rede que o proxy reverso, onde faríamos o balanceamento de carga.

```bash
docker network create \
  --subnet 192.168.100.0/24 \
  --gateway 192.168.100.1 \
  proxy-reverso

git clone https://github.com/ivandrailvomevanio/dev.git
cd dev/


docker-compose up -d

http://localhost:8181


##################################

BACKUP DO BANCO DE DADOS

Foi adicionado script para fazer o backup do banco de dados todos os dias, às 18h e adicionado à crontab.

####################################################################

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

mysqldump -h 127.0.0.1 -P 3306 -u$DB_USER -p$DB_PASS $DB_NAME \
	    > "$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"

find "$BACKUP_DIR" -type f -name "${DB_NAME}_backup_*.sql" -mtime +7 -exec rm {} \;

echo "Backup finalizado: $BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"
