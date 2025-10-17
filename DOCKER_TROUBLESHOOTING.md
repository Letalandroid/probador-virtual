# Docker Troubleshooting Guide

## Problemas Comunes y Soluciones

### 1. Error de pnpm-lock.yaml desactualizado

**Error:**
```
ERR_PNPM_OUTDATED_LOCKFILE Cannot install with "frozen-lockfile" because pnpm-lock.yaml is not up to date
```

**Solución:**
```bash
# Opción 1: Actualizar lockfiles automáticamente
./update-lockfiles.sh

# Opción 2: Usar Dockerfile con npm (ya configurado)
docker-compose up --build

# Opción 3: Actualizar manualmente
cd backend
pnpm install
cd ../frontend  
pnpm install
cd ../python
uv lock
```

### 2. Error de dependencias del sistema en Python

**Error:**
```
Package 'libgl1-mesa-glx' has no installation candidate
```

**Solución:**
El docker-compose.yml ya está configurado para usar `Dockerfile.minimal` que no requiere dependencias gráficas complejas.

### 3. Alternativas de Dockerfiles

#### Backend
- **`Dockerfile`** - Usa pnpm (requiere lockfile actualizado)
- **`Dockerfile.npm`** - Usa npm (más estable, ya configurado)

#### Python
- **`Dockerfile`** - Con dependencias gráficas completas
- **`Dockerfile.minimal`** - Sin dependencias gráficas (ya configurado)

### 4. Comandos de Construcción

#### Construir servicios individuales
```bash
# Backend con npm
docker build -f backend/Dockerfile.npm -t probador-backend ./backend

# Python minimal
docker build -f python/Dockerfile.minimal -t probador-python ./python

# Frontend
docker build -t probador-frontend ./frontend
```

#### Construir todos los servicios
```bash
# Usar docker-compose (recomendado)
docker-compose up --build

# O construir sin cache
docker-compose build --no-cache
```

### 5. Verificar Estado de los Servicios

```bash
# Ver logs
docker-compose logs

# Ver logs de un servicio específico
docker-compose logs backend
docker-compose logs python-api
docker-compose logs frontend

# Verificar estado
docker-compose ps

# Health checks
curl http://localhost:3000/health  # Backend
curl http://localhost:8000/health  # Python API
curl http://localhost:8080/health  # Frontend
```

### 6. Limpiar y Reconstruir

```bash
# Parar todos los servicios
docker-compose down

# Limpiar volúmenes
docker-compose down -v

# Limpiar imágenes
docker system prune -a

# Reconstruir desde cero
docker-compose up --build --force-recreate
```

### 7. Variables de Entorno

#### Archivo .env en la raíz
```env
# Database
DATABASE_URL=postgresql://postgres:password@postgres:5432/probador_virtual

# JWT
JWT_SECRET=your-super-secret-jwt-key

# Supabase
SUPABASE_URL=https://schbbdodgajmbzeeriwd.supabase.co
SUPABASE_ANON_KEY=your_supabase_key

# Python AI
GEMINI_API_KEY=your_gemini_api_key
```

#### Archivo .env en python/
```env
GEMINI_API_KEY=your_gemini_api_key_here
HOST=0.0.0.0
PORT=8000
RELOAD=false
```

### 8. Desarrollo vs Producción

#### Desarrollo (sin Docker)
```bash
# Backend
cd backend && npm run start:dev

# Frontend  
cd frontend && npm run dev

# Python API
cd python && python3 run_api.py
```

#### Producción (con Docker)
```bash
# Todos los servicios
docker-compose up -d

# Servicios específicos
docker-compose up -d backend frontend python-api
```

### 9. Monitoreo y Debugging

```bash
# Entrar a un contenedor
docker-compose exec backend sh
docker-compose exec python-api bash

# Ver uso de recursos
docker stats

# Ver logs en tiempo real
docker-compose logs -f

# Verificar configuración
docker-compose config
```

### 10. Problemas Específicos

#### Backend no inicia
- Verificar variables de entorno
- Revisar logs: `docker-compose logs backend`
- Verificar conexión a base de datos

#### Python API no responde
- Verificar GEMINI_API_KEY
- Revisar logs: `docker-compose logs python-api`
- Verificar health check: `curl http://localhost:8000/health`

#### Frontend no carga
- Verificar que backend esté corriendo
- Revisar logs: `docker-compose logs frontend`
- Verificar variables de entorno del frontend

### 11. Scripts de Utilidad

```bash
# Actualizar lockfiles
./update-lockfiles.sh

# Configurar Python API
cd python && ./setup-env.sh

# Gestión de Docker
./docker-scripts.sh start
./docker-scripts.sh stop
./docker-scripts.sh logs
./docker-scripts.sh health
```

## Contacto

Si encuentras otros problemas, revisa los logs y verifica la configuración de variables de entorno.
