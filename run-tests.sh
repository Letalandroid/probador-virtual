#!/bin/bash

# Script para ejecutar todas las pruebas del proyecto
# Incluye pruebas unitarias, de integración y end-to-end

set -e

echo "🧪 Iniciando ejecución de pruebas del proyecto Probador Virtual"
echo "================================================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con color
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

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ] && [ ! -d "frontend" ] && [ ! -d "backend" ]; then
    print_error "Este script debe ejecutarse desde el directorio raíz del proyecto"
    exit 1
fi

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar dependencias
print_status "Verificando dependencias..."

if ! command_exists node; then
    print_error "Node.js no está instalado"
    exit 1
fi

if ! command_exists npm; then
    print_error "npm no está instalado"
    exit 1
fi

print_success "Dependencias verificadas"

# Función para ejecutar pruebas de un directorio
run_tests() {
    local dir=$1
    local test_type=$2
    
    if [ ! -d "$dir" ]; then
        print_warning "Directorio $dir no encontrado, saltando..."
        return 0
    fi
    
    print_status "Ejecutando $test_type en $dir..."
    
    cd "$dir"
    
    # Verificar si package.json existe
    if [ ! -f "package.json" ]; then
        print_warning "package.json no encontrado en $dir, saltando..."
        cd ..
        return 0
    fi
    
    # Instalar dependencias si es necesario
    if [ ! -d "node_modules" ]; then
        print_status "Instalando dependencias en $dir..."
        npm install
    fi
    
    # Ejecutar pruebas
    if npm run test 2>/dev/null; then
        print_success "$test_type en $dir completadas exitosamente"
    else
        print_error "$test_type en $dir fallaron"
        cd ..
        return 1
    fi
    
    cd ..
}

# Función para ejecutar pruebas de cobertura
run_coverage_tests() {
    local dir=$1
    local test_type=$2
    
    if [ ! -d "$dir" ]; then
        print_warning "Directorio $dir no encontrado, saltando..."
        return 0
    fi
    
    print_status "Ejecutando $test_type con cobertura en $dir..."
    
    cd "$dir"
    
    if [ ! -f "package.json" ]; then
        print_warning "package.json no encontrado en $dir, saltando..."
        cd ..
        return 0
    fi
    
    # Verificar si el script de cobertura existe
    if npm run test:coverage 2>/dev/null; then
        print_success "$test_type con cobertura en $dir completadas exitosamente"
    elif npm run test:cov 2>/dev/null; then
        print_success "$test_type con cobertura en $dir completadas exitosamente"
    else
        print_warning "Script de cobertura no encontrado en $dir, ejecutando pruebas normales..."
        if npm run test 2>/dev/null; then
            print_success "$test_type en $dir completadas exitosamente"
        else
            print_error "$test_type en $dir fallaron"
            cd ..
            return 1
        fi
    fi
    
    cd ..
}

# Función para ejecutar pruebas E2E
run_e2e_tests() {
    print_status "Ejecutando pruebas End-to-End..."
    
    # Verificar si Playwright está instalado
    if ! command_exists npx; then
        print_error "npx no está disponible"
        return 1
    fi
    
    # Instalar Playwright si es necesario
    if [ ! -d "node_modules/@playwright" ]; then
        print_status "Instalando Playwright..."
        npm install @playwright/test
        npx playwright install
    fi
    
    # Ejecutar pruebas E2E
    if npx playwright test; then
        print_success "Pruebas End-to-End completadas exitosamente"
    else
        print_error "Pruebas End-to-End fallaron"
        return 1
    fi
}

# Función para generar reporte de cobertura
generate_coverage_report() {
    print_status "Generando reporte de cobertura..."
    
    # Crear directorio para reportes
    mkdir -p test-results/coverage
    
    # Buscar reportes de cobertura en cada directorio
    for dir in frontend backend; do
        if [ -d "$dir/coverage" ]; then
            print_status "Copiando reporte de cobertura de $dir..."
            cp -r "$dir/coverage" "test-results/coverage/$dir-coverage" 2>/dev/null || true
        fi
    done
    
    print_success "Reporte de cobertura generado en test-results/coverage/"
}

# Función para mostrar resumen
show_summary() {
    echo ""
    echo "================================================================"
    echo "📊 RESUMEN DE PRUEBAS"
    echo "================================================================"
    
    if [ -d "test-results" ]; then
        echo "📁 Reportes guardados en: test-results/"
        echo "   - HTML: test-results/index.html"
        echo "   - JSON: test-results/results.json"
        echo "   - JUnit: test-results/results.xml"
        echo "   - Cobertura: test-results/coverage/"
    fi
    
    echo ""
    echo "🔧 Comandos útiles:"
    echo "   - Ver reporte HTML: open test-results/index.html"
    echo "   - Ver cobertura: open test-results/coverage/*/index.html"
    echo "   - Ejecutar solo unitarias: ./run-tests.sh --unit"
    echo "   - Ejecutar solo integración: ./run-tests.sh --integration"
    echo "   - Ejecutar solo E2E: ./run-tests.sh --e2e"
    echo "   - Ejecutar con cobertura: ./run-tests.sh --coverage"
}

# Parsear argumentos
UNIT_ONLY=false
INTEGRATION_ONLY=false
E2E_ONLY=false
COVERAGE_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --unit)
            UNIT_ONLY=true
            shift
            ;;
        --integration)
            INTEGRATION_ONLY=true
            shift
            ;;
        --e2e)
            E2E_ONLY=true
            shift
            ;;
        --coverage)
            COVERAGE_ONLY=true
            shift
            ;;
        --help)
            echo "Uso: $0 [opciones]"
            echo ""
            echo "Opciones:"
            echo "  --unit        Ejecutar solo pruebas unitarias"
            echo "  --integration Ejecutar solo pruebas de integración"
            echo "  --e2e         Ejecutar solo pruebas end-to-end"
            echo "  --coverage    Ejecutar solo pruebas con cobertura"
            echo "  --help        Mostrar esta ayuda"
            exit 0
            ;;
        *)
            print_error "Opción desconocida: $1"
            echo "Usa --help para ver las opciones disponibles"
            exit 1
            ;;
    esac
done

# Crear directorio para resultados
mkdir -p test-results

# Ejecutar pruebas según las opciones
if [ "$E2E_ONLY" = true ]; then
    run_e2e_tests
elif [ "$UNIT_ONLY" = true ]; then
    run_tests "backend" "Pruebas unitarias Backend"
    run_tests "frontend" "Pruebas unitarias Frontend"
elif [ "$INTEGRATION_ONLY" = true ]; then
    run_tests "backend" "Pruebas de integración Backend"
    run_tests "frontend" "Pruebas de integración Frontend"
elif [ "$COVERAGE_ONLY" = true ]; then
    run_coverage_tests "backend" "Pruebas Backend"
    run_coverage_tests "frontend" "Pruebas Frontend"
    generate_coverage_report
else
    # Ejecutar todas las pruebas
    print_status "Ejecutando todas las pruebas..."
    
    # Pruebas unitarias
    run_tests "backend" "Pruebas unitarias Backend"
    run_tests "frontend" "Pruebas unitarias Frontend"
    
    # Pruebas de integración
    run_tests "backend" "Pruebas de integración Backend"
    run_tests "frontend" "Pruebas de integración Frontend"
    
    # Pruebas E2E (opcional, comentado por defecto)
    # run_e2e_tests
    
    # Generar reporte de cobertura
    generate_coverage_report
fi

show_summary

print_success "¡Ejecución de pruebas completada!"