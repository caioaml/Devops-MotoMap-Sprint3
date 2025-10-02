#!/bin/bash

# ===================================
# CRIAR AZURE SQL DATABASE
# ===================================

# Configurações
RESOURCE_GROUP="rg-sql-dimdim"
LOCATION="eastus2"
SQL_SERVER_NAME="sql-server-dimdim-rm556325-eastus2"
SQL_ADMIN_USER="user-dimdim"
SQL_ADMIN_PASSWORD="Fiap@2tdsvms"
DATABASE_NAME="motosdb"

echo "Criando Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Criando SQL Server..."
az sql server create \
  --name $SQL_SERVER_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --admin-user $SQL_ADMIN_USER \
  --admin-password $SQL_ADMIN_PASSWORD \
  --enable-public-network true

echo "Criando banco de dados..."
az sql db create \
  --resource-group $RESOURCE_GROUP \
  --server $SQL_SERVER_NAME \
  --name $DATABASE_NAME \
  --service-objective Basic \
  --backup-storage-redundancy Local

echo "Configurando firewall para Azure..."
az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $SQL_SERVER_NAME \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

echo "Configurando firewall publico..."
az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $SQL_SERVER_NAME \
  --name AllowAll \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

SQL_HOST="${SQL_SERVER_NAME}.database.windows.net"

echo ""
echo "SQL Server criado com sucesso!"
echo "============================================"
echo "Host: $SQL_HOST"
echo "Usuario: $SQL_ADMIN_USER"
echo "Senha: $SQL_ADMIN_PASSWORD"
echo "Banco: $DATABASE_NAME"
echo "Porta: 1433"
echo ""
echo "String de Conexao:"
echo "jdbc:sqlserver://${SQL_HOST}:1433;database=${DATABASE_NAME};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
echo "============================================"
