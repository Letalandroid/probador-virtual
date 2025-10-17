#!/bin/bash

# Docker management scripts for Probador Virtual

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to show help
show_help() {
    echo "Probador Virtual Docker Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start       Start all services"
    echo "  stop        Stop all services"
    echo "  restart     Restart all services"
    echo "  build       Build all services"
    echo "  logs        Show logs for all services"
    echo "  logs [svc]  Show logs for specific service (backend|frontend|python-api|postgres|redis)"
    echo "  status      Show status of all services"
    echo "  clean       Clean up containers, images, and volumes"
    echo "  dev         Start in development mode (with hot reload)"
    echo "  test        Run tests for all services"
    echo "  health      Check health of all services"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs backend"
    echo "  $0 clean"
}

# Function to start services
start_services() {
    print_status "Starting all services..."
    check_docker
    docker-compose up -d
    print_success "All services started!"
    print_status "Frontend: http://localhost:8080"
    print_status "Backend: http://localhost:3000"
    print_status "Python API: http://localhost:8000"
}

# Function to stop services
stop_services() {
    print_status "Stopping all services..."
    docker-compose down
    print_success "All services stopped!"
}

# Function to restart services
restart_services() {
    print_status "Restarting all services..."
    docker-compose restart
    print_success "All services restarted!"
}

# Function to build services
build_services() {
    print_status "Building all services..."
    check_docker
    docker-compose build --no-cache
    print_success "All services built!"
}

# Function to show logs
show_logs() {
    if [ -n "$1" ]; then
        print_status "Showing logs for $1..."
        docker-compose logs -f "$1"
    else
        print_status "Showing logs for all services..."
        docker-compose logs -f
    fi
}

# Function to show status
show_status() {
    print_status "Service status:"
    docker-compose ps
}

# Function to clean up
clean_up() {
    print_warning "This will remove all containers, images, and volumes. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_status "Cleaning up..."
        docker-compose down -v --remove-orphans
        docker system prune -a -f
        print_success "Cleanup completed!"
    else
        print_status "Cleanup cancelled."
    fi
}

# Function to start in development mode
start_dev() {
    print_status "Starting in development mode..."
    print_warning "This will start services individually for hot reload."
    print_status "Make sure to run each service in separate terminals:"
    echo ""
    echo "Terminal 1 - Backend:"
    echo "  cd backend && npm run start:dev"
    echo ""
    echo "Terminal 2 - Frontend:"
    echo "  cd frontend && npm run dev"
    echo ""
    echo "Terminal 3 - Python API:"
    echo "  cd python && uv run uvicorn src.api:app --reload --host 0.0.0.0 --port 8000"
    echo ""
    echo "Terminal 4 - Database:"
    echo "  docker-compose up postgres redis"
}

# Function to run tests
run_tests() {
    print_status "Running tests for all services..."
    
    print_status "Running backend tests..."
    docker-compose exec backend npm test || print_warning "Backend tests failed"
    
    print_status "Running frontend tests..."
    docker-compose exec frontend npm test || print_warning "Frontend tests failed"
    
    print_status "Running Python tests..."
    docker-compose exec python-api uv run pytest || print_warning "Python tests failed"
    
    print_success "All tests completed!"
}

# Function to check health
check_health() {
    print_status "Checking service health..."
    
    # Backend health
    if curl -f http://localhost:3000/health > /dev/null 2>&1; then
        print_success "Backend: Healthy"
    else
        print_error "Backend: Unhealthy"
    fi
    
    # Frontend health
    if curl -f http://localhost:8080/health > /dev/null 2>&1; then
        print_success "Frontend: Healthy"
    else
        print_error "Frontend: Unhealthy"
    fi
    
    # Python API health
    if curl -f http://localhost:8000/health > /dev/null 2>&1; then
        print_success "Python API: Healthy"
    else
        print_error "Python API: Unhealthy"
    fi
}

# Main script logic
case "${1:-help}" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    build)
        build_services
        ;;
    logs)
        show_logs "$2"
        ;;
    status)
        show_status
        ;;
    clean)
        clean_up
        ;;
    dev)
        start_dev
        ;;
    test)
        run_tests
        ;;
    health)
        check_health
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
