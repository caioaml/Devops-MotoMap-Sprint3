#!/bin/bash

# ===================================
# CRIAR POSTGRESQL NO AZURE
# ===================================

# Configurações
RESOURCE_GROUP="rg-linux-free"
LOCATION="brazilsouth"
PG_SERVER_NAME="pg-mottu-$(date +%s | tail -c 8)"
PG_ADMIN_USER="adminmottu"
PG_ADMIN_PASSWORD="Mottu2025Secure!"
DATABASE_NAME="motosdb"

echo "🚀 Criando PostgreSQL no Azure..."

# Criar servidor PostgreSQL
echo "📦 Criando servidor PostgreSQL..."
az postgres flexible-server create \
  --resource-group $RESOURCE_GROUP \
  --name $PG_SERVER_NAME \
  --location $LOCATION \
  --admin-user $PG_ADMIN_USER \
  --admin-password $PG_ADMIN_PASSWORD \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32 \
  --version 14 \
  --public-access 0.0.0.0 \
  --yes

if [ $? -ne 0 ]; then
    echo "❌ Erro ao criar servidor PostgreSQL!"
    exit 1
fi

# Criar banco de dados
echo "🗄️ Criando banco de dados..."
az postgres flexible-server db create \
  --resource-group $RESOURCE_GROUP \
  --server-name $PG_SERVER_NAME \
  --database-name $DATABASE_NAME

# Configurar firewall
echo "🔥 Configurando firewall..."
az postgres flexible-server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --name $PG_SERVER_NAME \
  --rule-name AllowAllAzure \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

# Mostrar informações
PG_HOST="${PG_SERVER_NAME}.postgres.database.azure.com"

echo ""
echo "✅ PostgreSQL criado com sucesso!"
echo "============================================"
echo "📝 GUARDE ESTAS INFORMAÇÕES:"
echo "============================================"
echo "Host: $PG_HOST"
echo "Usuário: $PG_ADMIN_USER"
echo "Senha: $PG_ADMIN_PASSWORD"
echo "Banco: $DATABASE_NAME"
echo "Porta: 5432"
echo ""
echo "String de Conexão:"
echo "jdbc:postgresql://${PG_HOST}:5432/${DATABASE_NAME}?ssl=true&sslmode=require"
echo "============================================"
echo ""
echo "⚠️ COPIE ESTAS INFORMAÇÕES!"
echo ""
echo "Para usar no script de deploy:"
echo "PG_HOST=\"${PG_HOST}\""
echo "PG_USER=\"${PG_ADMIN_USER}\""
echo "PG_PASSWORD=\"${PG_ADMIN_PASSWORD}\""
