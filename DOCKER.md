# Docker Setup para Probador Virtual

Este proyecto incluye configuraciones de Docker para todos los servicios: Backend (NestJS), Frontend (React), Python AI API y PostgreSQL.

## Servicios Incluidos

- **Backend**: NestJS API en puerto 3000
- **Frontend**: React + Vite en puerto 8080
- **Python API**: FastAPI para IA en puerto 8000
- **PostgreSQL**: Base de datos en puerto 5432
- **Redis**: Cache en puerto 6379

## Requisitos Previos

- Docker
- Docker Compose

## Uso Rápido

### 1. Clonar y configurar

```bash
git clone <repository-url>
cd probador_virtual
```

### 2. Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
# Database
DATABASE_URL=postgresql://postgres:password@postgres:5432/probador_virtual

# JWT
JWT_SECRET=your-super-secret-jwt-key

# Supabase
SUPABASE_URL=https://schbbdodgajmbzeeriwd.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjaGJiZG9kZ2FqbWJ6ZWVyaXdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3MjMxNjMsImV4cCI6MjA3NDI5OTE2M30.AfrB3ZcQTqGkQzoMPIlINhmkcVvSq8ew29oVwypgKD0

# Python AI API
GEMINI_API_KEY=your_gemini_api_key_here
```

**Para el servicio de Python AI:**
1. Ve al directorio `python/`
2. Ejecuta: `./setup-env.sh` (o `bash setup-env.sh`)
3. Sigue las instrucciones para configurar tu API key de Gemini

**Obtener API key de Gemini:**
- Visita: https://makersuite.google.com/app/apikey
- Crea una nueva API key
- Cópiala en el archivo `.env`

### 3. Ejecutar todos los servicios

```bash
docker-compose up --build
```

### 4. Acceder a la aplicación

- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:3000
- **Python AI API**: http://localhost:8000
- **PostgreSQL**: localhost:5432

## Comandos Útiles

### Construir solo un servicio

```bash
# Backend
docker-compose build backend

# Frontend
docker-compose build frontend

# Python API
docker-compose build python-api
```

### Ejecutar en segundo plano

```bash
docker-compose up -d
```

### Ver logs

```bash
# Todos los servicios
docker-compose logs

# Servicio específico
docker-compose logs backend
docker-compose logs frontend
docker-compose logs python-api
```

### Parar servicios

```bash
docker-compose down
```

### Parar y eliminar volúmenes

```bash
docker-compose down -v
```

### Reconstruir desde cero

```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

## Desarrollo

### Modo desarrollo con hot reload

Para desarrollo, es recomendable ejecutar los servicios individualmente:

```bash
# Terminal 1 - Backend
cd backend
npm run start:dev

# Terminal 2 - Frontend
cd frontend
npm run dev

# Terminal 3 - Python API
cd python
uv run uvicorn src.api:app --reload --host 0.0.0.0 --port 8000
```

### Ejecutar tests

```bash
# Backend tests
cd backend
docker-compose exec backend npm test

# Frontend tests
cd frontend
docker-compose exec frontend npm test

# Python tests
cd python
docker-compose exec python-api uv run pytest
```

## Estructura de Dockerfiles

### Backend (NestJS)
- **Base**: Node.js 18 Alpine
- **Multi-stage**: deps → builder → runner
- **Optimizaciones**: Prisma client generation, non-root user
- **Puerto**: 3000

### Frontend (React + Vite)
- **Base**: Node.js 18 Alpine → Nginx Alpine
- **Multi-stage**: deps → builder → nginx
- **Optimizaciones**: Gzip compression, static asset caching
- **Puerto**: 8080

### Python API (FastAPI)
- **Base**: Python 3.11 Slim
- **Optimizaciones**: uv package manager, non-root user
- **Health check**: Incluido
- **Puerto**: 8000

## Troubleshooting

### Problemas comunes

1. **Puerto ya en uso**
   ```bash
   # Verificar qué proceso usa el puerto
   lsof -i :3000
   # Cambiar puerto en docker-compose.yml
   ```

2. **Problemas de permisos**
   ```bash
   # En Linux/Mac
   sudo chown -R $USER:$USER .
   ```

3. **Limpiar Docker**
   ```bash
   docker system prune -a
   docker volume prune
   ```

4. **Verificar logs de errores**
   ```bash
   docker-compose logs --tail=100
   ```

### Health Checks

- **Backend**: `curl http://localhost:3000/health`
- **Frontend**: `curl http://localhost:8080/health`
- **Python API**: `curl http://localhost:8000/health`

## Producción

Para despliegue en producción:

1. Actualizar variables de entorno
2. Usar un registry de imágenes (Docker Hub, ECR, etc.)
3. Configurar un reverse proxy (Nginx, Traefik)
4. Usar un orquestador (Kubernetes, Docker Swarm)
5. Configurar monitoreo y logging

## Notas

- Los volúmenes persisten los datos de PostgreSQL y Redis
- Las imágenes generadas por IA se almacenan en volúmenes montados
- Todos los servicios usan usuarios no-root por seguridad
- Los Dockerfiles están optimizados para producción
