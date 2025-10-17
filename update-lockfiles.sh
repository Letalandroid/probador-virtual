#!/bin/bash

# Script para actualizar los lockfiles de los servicios

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

print_status "Actualizando lockfiles de los servicios..."

# Backend - Actualizar pnpm-lock.yaml
if [ -d "backend" ]; then
    print_status "Actualizando backend/pnpm-lock.yaml..."
    cd backend
    
    if command -v pnpm &> /dev/null; then
        pnpm install
        print_success "Backend lockfile actualizado"
    else
        print_warning "pnpm no está instalado. Instalando..."
        npm install -g pnpm
        pnpm install
        print_success "Backend lockfile actualizado"
    fi
    
    cd ..
else
    print_warning "Directorio backend no encontrado"
fi

# Frontend - Actualizar pnpm-lock.yaml
if [ -d "frontend" ]; then
    print_status "Actualizando frontend/pnpm-lock.yaml..."
    cd frontend
    
    if command -v pnpm &> /dev/null; then
        pnpm install
        print_success "Frontend lockfile actualizado"
    else
        print_warning "pnpm no está instalado. Instalando..."
        npm install -g pnpm
        pnpm install
        print_success "Frontend lockfile actualizado"
    fi
    
    cd ..
else
    print_warning "Directorio frontend no encontrado"
fi

# Python - Actualizar uv.lock
if [ -d "python" ]; then
    print_status "Actualizando python/uv.lock..."
    cd python
    
    if command -v uv &> /dev/null; then
        uv lock
        print_success "Python lockfile actualizado"
    else
        print_warning "uv no está instalado. Instalando..."
        pip install uv
        uv lock
        print_success "Python lockfile actualizado"
    fi
    
    cd ..
else
    print_warning "Directorio python no encontrado"
fi

print_success "¡Todos los lockfiles han sido actualizados!"
print_status "Ahora puedes ejecutar: docker-compose up --build"
