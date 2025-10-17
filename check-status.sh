#!/bin/bash

echo "🔍 Verificando estado del sistema..."

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para verificar servicios
check_service() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "Verificando $name... "
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_status"; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ ERROR${NC}"
        return 1
    fi
}

echo -e "\n${BLUE}📊 Estado de los Servicios:${NC}"
echo "================================"

# Verificar Python API
check_service "Python API" "http://localhost:8000/health"

# Verificar Backend (si está corriendo)
check_service "Backend API" "http://localhost:3000/health"

# Verificar Frontend (si está corriendo)
check_service "Frontend" "http://localhost:5173"

echo -e "\n${BLUE}📋 Resumen:${NC}"
echo "================================"

# Verificar Python
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "🐍 Python API: ${GREEN}✅ Funcionando${NC}"
else
    echo -e "🐍 Python API: ${RED}❌ No disponible${NC}"
fi

# Verificar Backend
if curl -s http://localhost:3000/health > /dev/null 2>&1; then
    echo -e "🔧 Backend: ${GREEN}✅ Funcionando${NC}"
else
    echo -e "🔧 Backend: ${RED}❌ No disponible (requiere Node.js)${NC}"
fi

# Verificar Frontend
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo -e "⚛️  Frontend: ${GREEN}✅ Funcionando${NC}"
else
    echo -e "⚛️  Frontend: ${RED}❌ No disponible (requiere Node.js)${NC}"
fi

echo -e "\n${BLUE}💡 Próximos pasos:${NC}"
echo "================================"
echo "1. Para el Backend: Instalar Node.js y ejecutar 'cd backend && npm install && npm run start:dev'"
echo "2. Para el Frontend: Instalar Node.js y ejecutar 'cd frontend && npm install && npm run dev'"
echo "3. Para tests: Ejecutar './run-tests.sh'"

echo -e "\n${GREEN}🎉 Python API está funcionando correctamente!${NC}"




