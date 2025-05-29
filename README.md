# Projeto Docker: Apache + PHP-FPM + MariaDB

Este projeto configura um ambiente completo com Apache, PHP-FPM (FastCGI) e MariaDB usando Docker Compose. Ele foi desenvolvido como um ambiente de demonstração funcional e modular para aplicações PHP com banco de dados.

## 📦 Serviços

- **Apache**: Servidor web, configurado para encaminhar requisições PHP para o PHP-FPM via FastCGI.
- **PHP-FPM**: Interpretador PHP rodando em processo separado.
- **MariaDB**: Banco de dados relacional MySQL-compatible.
- **Volume persistente** para dados do banco.
- **Rede Docker customizada** para comunicação entre os containers.

---

## 📁 Estrutura de Diretórios
dev/
├── apache
│ └── httpd.conf # Configuração personalizada do Apache
├── html
│ └── index.php # Código PHP de teste (phpinfo)
├── .env # Variáveis de ambiente sensíveis
└── docker-compose.yml # Definição dos containers


---

## ⚙️ Pré-requisitos

- Docker
- Docker Compose
- Git (para clonar o projeto)

---

## 🌐 Criação da rede personalizada

Antes de subir os containers, **é necessário criar a rede `proxy-reverso` manualmente**, pois ela é externa ao `docker-compose.yml`.

```bash
docker network create \
  --subnet 192.168.100.0/24 \
  --gateway 192.168.100.1 \
  proxy-reverso

git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio


MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=mydb
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword

docker-compose up -d

http://localhost:8181


