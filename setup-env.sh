#!/bin/bash

# Script para configurar variables de entorno del proyecto Probador Virtual

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${PURPLE}===========================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}===========================================${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header "CONFIGURACIÓN DE VARIABLES DE ENTORNO - PROBADOR VIRTUAL"

# Función para crear archivo .env si no existe
create_env_file() {
    local file_path=$1
    local example_path=$2
    local service_name=$3
    
    if [ ! -f "$file_path" ]; then
        if [ -f "$example_path" ]; then
            cp "$example_path" "$file_path"
            print_success "Creado $file_path para $service_name"
        else
            print_warning "No se encontró $example_path para $service_name"
        fi
    else
        print_status "$file_path ya existe para $service_name"
    fi
}

# Función para solicitar input del usuario
get_user_input() {
    local prompt=$1
    local default_value=$2
    local var_name=$3
    
    if [ -n "$default_value" ]; then
        read -p "$prompt [$default_value]: " user_input
        echo "${user_input:-$default_value}"
    else
        read -p "$prompt: " user_input
        echo "$user_input"
    fi
}

print_status "Configurando variables de entorno para todos los servicios..."

# 1. Crear archivos .env desde ejemplos
print_header "1. CREANDO ARCHIVOS .ENV"

create_env_file ".env" "env.example" "proyecto principal"
create_env_file "frontend/.env" "frontend/env.example" "frontend"
create_env_file "backend/.env" "backend/env.example" "backend"
create_env_file "python/.env" "python/env.example" "python"

# 2. Configurar variables críticas
print_header "2. CONFIGURANDO VARIABLES CRÍTICAS"

# JWT Secret
print_status "Configurando JWT_SECRET..."
jwt_secret=$(get_user_input "Ingresa JWT_SECRET (clave secreta para tokens)" "your-super-secret-jwt-key-here" "JWT_SECRET")

# Database URL
print_status "Configurando DATABASE_URL..."
db_url=$(get_user_input "Ingresa DATABASE_URL (PostgreSQL)" "postgresql://postgres:password@localhost:5432/probador_virtual" "DATABASE_URL")

# Gemini API Key
print_status "Configurando GEMINI_API_KEY..."
print_warning "Necesitas obtener una clave de API de Google Gemini: https://ai.google.dev/"
gemini_key=$(get_user_input "Ingresa GEMINI_API_KEY" "" "GEMINI_API_KEY")

# 3. Actualizar archivos .env con valores del usuario
print_header "3. ACTUALIZANDO ARCHIVOS .ENV"

# Actualizar .env principal
if [ -f ".env" ]; then
    sed -i "s/JWT_SECRET=.*/JWT_SECRET=$jwt_secret/" .env
    sed -i "s|DATABASE_URL=.*|DATABASE_URL=$db_url|" .env
    if [ -n "$gemini_key" ]; then
        sed -i "s/GEMINI_API_KEY=.*/GEMINI_API_KEY=$gemini_key/" .env
    fi
    print_success "Actualizado .env principal"
fi

# Actualizar backend/.env
if [ -f "backend/.env" ]; then
    sed -i "s/JWT_SECRET=.*/JWT_SECRET=$jwt_secret/" backend/.env
    sed -i "s|DATABASE_URL=.*|DATABASE_URL=$db_url|" backend/.env
    print_success "Actualizado backend/.env"
fi

# Actualizar python/.env
if [ -f "python/.env" ] && [ -n "$gemini_key" ]; then
    sed -i "s/GEMINI_API_KEY=.*/GEMINI_API_KEY=$gemini_key/" python/.env
    print_success "Actualizado python/.env"
fi

# 4. Verificar configuración
print_header "4. VERIFICANDO CONFIGURACIÓN"

print_status "Verificando archivos .env creados..."
for env_file in ".env" "frontend/.env" "backend/.env" "python/.env"; do
    if [ -f "$env_file" ]; then
        print_success "✓ $env_file existe"
    else
        print_error "✗ $env_file no existe"
    fi
done

# 5. Mostrar resumen
print_header "5. RESUMEN DE CONFIGURACIÓN"

print_status "Variables configuradas:"
echo -e "  ${GREEN}JWT_SECRET${NC}: ${jwt_secret:0:20}..."
echo -e "  ${GREEN}DATABASE_URL${NC}: $db_url"
if [ -n "$gemini_key" ]; then
    echo -e "  ${GREEN}GEMINI_API_KEY${NC}: ${gemini_key:0:20}..."
else
    echo -e "  ${YELLOW}GEMINI_API_KEY${NC}: No configurada"
fi

print_header "6. PRÓXIMOS PASOS"

print_status "Para continuar con el desarrollo:"
echo -e "  ${BLUE}1.${NC} Instalar dependencias:"
echo -e "     ${YELLOW}cd backend && npm install${NC}"
echo -e "     ${YELLOW}cd frontend && npm install${NC}"
echo -e "     ${YELLOW}cd python && uv sync${NC}"

echo -e "  ${BLUE}2.${NC} Configurar base de datos:"
echo -e "     ${YELLOW}cd backend && npx prisma migrate dev${NC}"
echo -e "     ${YELLOW}cd backend && npx prisma db seed${NC}"

echo -e "  ${BLUE}3.${NC} Ejecutar servicios:"
echo -e "     ${YELLOW}npm run dev:all${NC} (si existe)"
echo -e "     ${YELLOW}O usar Docker: docker-compose up --build${NC}"

print_success "¡Configuración de variables de entorno completada!"
print_warning "Recuerda: Nunca commitees archivos .env con claves reales"
