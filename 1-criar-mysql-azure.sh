#!/bin/bash

# ===================================
# CRIAR MYSQL NO AZURE (Single Server)
# ===================================

# Configurações
RESOURCE_GROUP="rg-linux-free"
LOCATION="brazilsouth"
MYSQL_SERVER_NAME="mysql-mottu-$(date +%s | tail -c 8)"
MYSQL_ADMIN_USER="adminmottu"
MYSQL_ADMIN_PASSWORD="Mottu2025Secure!"
DATABASE_NAME="motosdb"

echo "🚀 Criando MySQL no Azure (Single Server)..."

# Criar servidor MySQL
echo "📦 Criando servidor MySQL..."
az mysql server create \
  --resource-group $RESOURCE_GROUP \
  --name $MYSQL_SERVER_NAME \
  --location $LOCATION \
  --admin-user $MYSQL_ADMIN_USER \
  --admin-password $MYSQL_ADMIN_PASSWORD \
  --sku-name B_Gen5_1 \
  --storage-size 5120 \
  --version 5.7 \
  --ssl-enforcement Disabled

if [ $? -ne 0 ]; then
    echo "❌ Erro ao criar servidor MySQL!"
    exit 1
fi

# Criar banco de dados
echo "🗄️ Criando banco de dados..."
az mysql db create \
  --resource-group $RESOURCE_GROUP \
  --server-name $MYSQL_SERVER_NAME \
  --name $DATABASE_NAME

# Configurar firewall para permitir serviços do Azure
echo "🔥 Configurando firewall para Azure..."
az mysql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server-name $MYSQL_SERVER_NAME \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

# Configurar firewall para acesso público (para testes)
echo "🔥 Configurando firewall público..."
az mysql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server-name $MYSQL_SERVER_NAME \
  --name AllowAll \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

# Mostrar informações
MYSQL_HOST="${MYSQL_SERVER_NAME}.mysql.database.azure.com"

echo ""
echo "✅ MySQL criado com sucesso!"
echo "============================================"
echo "📝 GUARDE ESTAS INFORMAÇÕES:"
echo "============================================"
echo "Host: $MYSQL_HOST"
echo "Usuário: $MYSQL_ADMIN_USER@$MYSQL_SERVER_NAME"
echo "Senha: $MYSQL_ADMIN_PASSWORD"
echo "Banco: $DATABASE_NAME"
echo "Porta: 3306"
echo ""
echo "String de Conexão:"
echo "jdbc:mysql://${MYSQL_HOST}:3306/${DATABASE_NAME}?useSSL=false"
echo "============================================"
echo ""
echo "⚠️ COPIE ESTAS INFORMAÇÕES! Você vai precisar no próximo passo."
echo ""
echo "Para usar no script de deploy:"
echo "MYSQL_HOST=\"${MYSQL_HOST}\""
echo "MYSQL_USER=\"${MYSQL_ADMIN_USER}@${MYSQL_SERVER_NAME}\""
echo "MYSQL_PASSWORD=\"${MYSQL_ADMIN_PASSWORD}\""
