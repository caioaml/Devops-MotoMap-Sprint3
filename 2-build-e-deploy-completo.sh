#!/bin/bash
# ===================================
# BUILD E DEPLOY COMPLETO - SQL SERVER
# ===================================
# MODIFIQUE ESTAS VARIÁVEIS!
ACR_NAME="caioacr"
RESOURCE_GROUP="rg-linux-free"
IMAGE_NAME="app-mottu"
IMAGE_TAG="v1"
CONTAINER_NAME="mottu-app"

# DADOS DO SQL SERVER
SQL_HOST="sql-server-dimdim-rm556325-eastus2.database.windows.net"
SQL_USER="user-dimdim"
SQL_PASSWORD="Fiap@2tdsvms"
SQL_DATABASE="motosdb"

echo "Iniciando build e deploy..."

# 1. Login no ACR
echo "Login no ACR..."
az acr login --name $ACR_NAME

# 2. Construindo a imagem Docker
echo "Construindo imagem Docker..."
docker build -t $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG .

# 3. Enviando para o ACR
echo "Enviando para ACR..."
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# 4. Obtendo credenciais
echo "Obtendo credenciais..."
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv)

# 5. Removendo container antigo, se existir
echo "Removendo container antigo..."
az container delete --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --yes --no-wait

# 6. Criando o novo container com o banco SQL Server
echo "Criando container..."
az container create \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --image $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG \
  --cpu 1 \
  --memory 1.5 \
  --registry-login-server $ACR_NAME.azurecr.io \
  --registry-username $ACR_NAME \
  --registry-password $ACR_PASSWORD \
  --ports 8080 \
  --ip-address Public \
  --os-type Linux \
  --location brazilsouth \
  --dns-name-label $CONTAINER_NAME \
  --environment-variables \
    SPRING_DATASOURCE_URL="jdbc:sqlserver://$SQL_HOST:1433;database=$SQL_DATABASE" \
    SPRING_DATASOURCE_USERNAME="$SQL_USER" \
    SPRING_DATASOURCE_PASSWORD="$SQL_PASSWORD" 

# 7. Aguardar inicialização
echo "Aguardando container iniciar..."
sleep 30  # Aguarde 30 segundos para garantir que o container subiu corretamente

# 8. Obter informações
CONTAINER_IP=$(az container show \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --query "ipAddress.ip" \
  --output tsv)

# 9. Exibir informações
echo ""
echo "Deploy concluído!"
echo "============================================"
echo "IP Público: $CONTAINER_IP"
echo "URL da API: http://${CONTAINER_IP}:8080"
echo "Endpoint Motos: http://${CONTAINER_IP}:8080/motos"
echo "============================================"
echo ""
echo "Teste:"
echo "curl http://${CONTAINER_IP}:8080/motos"
echo ""
echo "Ver logs:"
echo "az container logs -g $RESOURCE_GROUP -n $CONTAINER_NAME"
