# Variables de Entorno - Probador Virtual

## 📋 Resumen de Variables por Servicio

### 🎨 **Frontend (React + Vite)**
### 🚀 **Backend (NestJS + Prisma)**
### 🐍 **Python (FastAPI + Gemini AI)**

---

## 🎨 **FRONTEND** - Variables de Entorno

### Archivo: `.env` (en la raíz del proyecto)

```env
# ===========================================
# FRONTEND - Variables de Entorno
# ===========================================

# API Backend URL
VITE_API_BASE_URL=http://localhost:3000

# Python AI API URL
VITE_PYTHON_API_URL=http://localhost:8000

# Supabase Configuration
VITE_SUPABASE_URL=https://schbbdodgajmbzeeriwd.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjaGJiZG9kZ2FqbWJ6ZWVyaXdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3MjMxNjMsImV4cCI6MjA3NDI5OTE2M30.AfrB3ZcQTqGkQzoMPIlINhmkcVvSq8ew29oVwypgKD0

# Environment
NODE_ENV=development
```

### Variables en `frontend/src/config/env.ts`:
- `VITE_API_BASE_URL` - URL del backend (default: http://localhost:3000)
- `VITE_PYTHON_API_URL` - URL del servicio Python AI (default: http://localhost:8000)
- `VITE_SUPABASE_URL` - URL de Supabase
- `VITE_SUPABASE_ANON_KEY` - Clave anónima de Supabase

---

## 🚀 **BACKEND** - Variables de Entorno

### Archivo: `.env` (en la raíz del proyecto)

```env
# ===========================================
# BACKEND - Variables de Entorno
# ===========================================

# Database
DATABASE_URL=postgresql://postgres:password@localhost:5432/probador_virtual

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-here
JWT_EXPIRES_IN=24h

# Server Configuration
PORT=3000
NODE_ENV=development

# AI Service Configuration
AI_API_URL=http://localhost:8000

# Supabase Configuration (opcional)
SUPABASE_URL=https://schbbdodgajmbzeeriwd.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjaGJiZG9kZ2FqbWJ6ZWVyaXdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3MjMxNjMsImV4cCI6MjA3NDI5OTE2M30.AfrB3ZcQTqGkQzoMPIlINhmkcVvSq8ew29oVwypgKD0
```

### Variables utilizadas en el código:
- `DATABASE_URL` - URL de conexión a PostgreSQL (requerida por Prisma)
- `JWT_SECRET` - Clave secreta para firmar tokens JWT
- `JWT_EXPIRES_IN` - Tiempo de expiración de tokens JWT (default: 24h)
- `PORT` - Puerto del servidor (default: 3000)
- `NODE_ENV` - Entorno de ejecución
- `AI_API_URL` - URL del servicio Python AI (default: http://localhost:8000)
- `SUPABASE_URL` - URL de Supabase (opcional)
- `SUPABASE_ANON_KEY` - Clave anónima de Supabase (opcional)

---

## 🐍 **PYTHON** - Variables de Entorno

### Archivo: `python/.env`

```env
# ===========================================
# PYTHON AI SERVICE - Variables de Entorno
# ===========================================

# Google Gemini API Configuration
GEMINI_API_KEY=your_gemini_api_key_here
# Alternative: GOOGLE_API_KEY=your_google_api_key_here

# Server Configuration
HOST=0.0.0.0
PORT=8000
RELOAD=false

# Optional: Logging level
LOG_LEVEL=info
```

### Variables utilizadas en el código:
- `GEMINI_API_KEY` - Clave de API de Google Gemini (requerida)
- `GOOGLE_API_KEY` - Clave alternativa de Google API
- `HOST` - Host del servidor (default: 0.0.0.0)
- `PORT` - Puerto del servidor (default: 8000)
- `RELOAD` - Recarga automática en desarrollo (default: false)
- `LOG_LEVEL` - Nivel de logging (default: info)

---

## 🐳 **DOCKER COMPOSE** - Variables de Entorno

### Archivo: `.env` (en la raíz del proyecto)

```env
# ===========================================
# DOCKER COMPOSE - Variables de Entorno
# ===========================================

# Database
DATABASE_URL=postgresql://postgres:password@postgres:5432/probador_virtual

# JWT
JWT_SECRET=your-super-secret-jwt-key-here

# Supabase
SUPABASE_URL=https://schbbdodgajmbzeeriwd.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjaGJiZG9kZ2FqbWJ6ZWVyaXdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3MjMxNjMsImV4cCI6MjA3NDI5OTE2M30.AfrB3ZcQTqGkQzoMPIlINhmkcVvSq8ew29oVwypgKD0

# Python AI
GEMINI_API_KEY=your_gemini_api_key_here
```

---

## 📁 **Estructura de Archivos de Variables**

```
probador_virtual/
├── .env                          # Variables principales (Docker Compose)
├── frontend/
│   └── .env.local               # Variables específicas del frontend (opcional)
├── backend/
│   └── .env                     # Variables específicas del backend (opcional)
└── python/
    ├── .env                     # Variables del servicio Python AI
    └── env.example              # Plantilla de variables
```

---

## 🔧 **Configuración por Entorno**

### **Desarrollo Local**
```bash
# Frontend
cd frontend
npm run dev

# Backend
cd backend
npm run start:dev

# Python AI
cd python
python3 run_api.py
```

### **Docker Compose**
```bash
# Todos los servicios
docker-compose up --build

# Servicios específicos
docker-compose up -d backend frontend python-api
```

### **Producción**
```bash
# Usar variables de entorno del sistema
export DATABASE_URL="postgresql://..."
export JWT_SECRET="your-secret"
export GEMINI_API_KEY="your-key"

# O usar archivos .env
docker-compose -f docker-compose.prod.yml up -d
```

---

## ⚠️ **Variables Críticas**

### **Requeridas para funcionamiento básico:**
- `DATABASE_URL` - Base de datos PostgreSQL
- `JWT_SECRET` - Autenticación
- `GEMINI_API_KEY` - Servicio de IA

### **Opcionales pero recomendadas:**
- `VITE_API_BASE_URL` - URL del backend
- `VITE_PYTHON_API_URL` - URL del servicio Python
- `SUPABASE_URL` y `SUPABASE_ANON_KEY` - Supabase

### **Solo para desarrollo:**
- `NODE_ENV=development`
- `RELOAD=true` (Python)

---

## 🚀 **Scripts de Configuración**

### **Configurar Python AI:**
```bash
cd python
./setup-env.sh
```

### **Actualizar lockfiles:**
```bash
./update-lockfiles.sh
```

### **Verificar configuración:**
```bash
# Verificar variables de Docker Compose
docker-compose config

# Verificar variables del sistema
env | grep -E "(DATABASE_URL|JWT_SECRET|GEMINI_API_KEY)"
```

---

## 📝 **Notas Importantes**

1. **Seguridad**: Nunca commitees archivos `.env` con claves reales
2. **Desarrollo**: Usa valores por defecto para desarrollo local
3. **Producción**: Usa variables de entorno del sistema o servicios de secretos
4. **Docker**: Las variables se pasan automáticamente desde el archivo `.env` principal
5. **Supabase**: Las claves mostradas son de ejemplo, usa las tuyas propias

---

## 🔗 **Enlaces Útiles**

- [Documentación de Vite - Variables de Entorno](https://vitejs.dev/guide/env-and-mode.html)
- [Documentación de NestJS - Configuración](https://docs.nestjs.com/techniques/configuration)
- [Documentación de Prisma - Variables de Entorno](https://www.prisma.io/docs/reference/database-reference/connection-urls)
- [Documentación de Google Gemini API](https://ai.google.dev/docs)
