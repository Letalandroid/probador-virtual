# Despliegue en la Nube
## Probador Virtual con IA - Guía de Despliegue

**Versión:** 1.0  
**Fecha:** 2025  
**Autor:** Carlos Moran Mauricio

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Arquitectura de Despliegue](#arquitectura-de-despliegue)
3. [Despliegue del Frontend en Vercel](#despliegue-del-frontend-en-vercel)
4. [Despliegue del Backend en Render](#despliegue-del-backend-en-render)
5. [Despliegue del Servicio de IA en Render](#despliegue-del-servicio-de-ia-en-render)
6. [Configuración de Base de Datos (Supabase)](#configuración-de-base-de-datos-supabase)
7. [Variables de Entorno](#variables-de-entorno)
8. [Configuración de Dominio](#configuración-de-dominio)
9. [CI/CD y Auto-Deploy](#cicd-y-auto-deploy)
10. [Verificación Post-Despliegue](#verificación-post-despliegue)
11. [Troubleshooting](#troubleshooting)

---

## Introducción

Este documento describe el proceso completo de despliegue de la aplicación **Probador Virtual con IA** en la nube. La aplicación está compuesta por tres servicios principales:

1. **Frontend** (React + Vite) → **Vercel**
2. **Backend API** (NestJS) → **Render**
3. **Servicio de IA** (Python FastAPI) → **Render**
4. **Base de Datos** (PostgreSQL) → **Supabase**

---

## Arquitectura de Despliegue

```
┌─────────────────────────────────────────────────────────┐
│                    INTERNET                             │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
┌───────▼──────┐  ┌───────▼──────┐  ┌───────▼──────┐
│   Frontend   │  │   Backend    │  │  AI Service  │
│   (Vercel)   │  │   (Render)   │  │   (Render)   │
│              │  │              │  │              │
│  React/Vite  │  │   NestJS     │  │  FastAPI     │
│  https://    │  │  https://    │  │  https://    │
│  app.vercel  │  │  api.render  │  │  ai.render   │
└───────┬──────┘  └───────┬──────┘  └───────┬──────┘
        │                 │                 │
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
                  ┌───────▼──────┐
                  │   Supabase   │
                  │  PostgreSQL  │
                  │   Storage    │
                  └──────────────┘
```

---

## Despliegue del Frontend en Vercel

### Prerrequisitos

- Cuenta en [Vercel](https://vercel.com)
- Repositorio Git (GitHub, GitLab, Bitbucket)
- Código del frontend listo para producción

### Paso 1: Preparar el Proyecto

1. **Asegurar que el build funciona localmente:**
   ```bash
   cd frontend
   npm run build
   ```

2. **Verificar `vercel.json` (si existe):**
   ```json
   {
     "buildCommand": "npm run build",
     "outputDirectory": "dist",
     "devCommand": "npm run dev",
     "installCommand": "npm install"
   }
   ```

### Paso 2: Conectar Repositorio en Vercel

1. **Iniciar sesión en Vercel**
   - Visita [vercel.com](https://vercel.com)
   - Inicia sesión con tu cuenta de GitHub/GitLab

2. **Importar Proyecto**
   - Haz clic en **"Add New Project"**
   - Selecciona tu repositorio
   - Selecciona la carpeta `frontend` como **Root Directory**

3. **Configurar Build Settings**
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
   - **Install Command**: `npm install`

### Paso 3: Configurar Variables de Entorno

En la configuración del proyecto en Vercel:

1. Ve a **Settings** → **Environment Variables**
2. Agrega las siguientes variables:

```env
VITE_API_URL=https://tu-backend.render.com
VITE_SUPABASE_URL=https://tu-proyecto.supabase.co
VITE_SUPABASE_ANON_KEY=tu_supabase_anon_key
```

### Paso 4: Desplegar

1. **Primer Despliegue**
   - Haz clic en **"Deploy"**
   - Vercel construirá y desplegará automáticamente
   - Obtendrás una URL: `https://tu-proyecto.vercel.app`

2. **Auto-Deploy**
   - Cada push a la rama `main` desplegará automáticamente
   - Los Pull Requests generan preview deployments

### Paso 5: Configurar Dominio Personalizado (Opcional)

1. Ve a **Settings** → **Domains**
2. Agrega tu dominio personalizado
3. Sigue las instrucciones para configurar DNS

---

## Despliegue del Backend en Render

### Prerrequisitos

- Cuenta en [Render](https://render.com)
- Repositorio Git
- Base de datos Supabase configurada

### Paso 1: Preparar el Proyecto

1. **Verificar `package.json`:**
   ```json
   {
     "scripts": {
       "start": "node dist/main",
       "build": "nest build",
       "start:prod": "node dist/main"
     }
   }
   ```

2. **Crear `render.yaml` (opcional, para infraestructura como código):**
   ```yaml
   services:
     - type: web
       name: probador-backend
       env: node
       buildCommand: npm install && npm run build
       startCommand: npm run start:prod
       envVars:
         - key: NODE_ENV
           value: production
   ```

### Paso 2: Crear Web Service en Render

1. **Iniciar sesión en Render**
   - Visita [render.com](https://render.com)
   - Inicia sesión con tu cuenta de GitHub

2. **Crear Nuevo Web Service**
   - Haz clic en **"New +"** → **"Web Service"**
   - Conecta tu repositorio
   - Selecciona el repositorio y la rama

3. **Configurar el Servicio**
   - **Name**: `probador-backend` (o el nombre que prefieras)
   - **Environment**: `Node`
   - **Region**: Selecciona la región más cercana
   - **Branch**: `main` (o la rama de producción)
   - **Root Directory**: `backend` (si el backend está en una subcarpeta)
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npm run start:prod`

### Paso 3: Configurar Variables de Entorno

En **Environment Variables** del servicio:

```env
NODE_ENV=production
PORT=10000
DATABASE_URL=postgresql://user:password@host:port/database
JWT_SECRET=tu_jwt_secret_muy_seguro_y_largo
JWT_EXPIRES_IN=7d
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_KEY=tu_supabase_service_key
AI_SERVICE_URL=https://tu-ai-service.render.com
```

### Paso 4: Configurar Base de Datos

1. **Ejecutar Migraciones**
   - Opción 1: En el **Shell** de Render, ejecuta:
     ```bash
     npx prisma migrate deploy
     npx prisma generate
     ```
   - Opción 2: Usa un script de build que ejecute las migraciones

2. **Verificar Conexión**
   - Revisa los logs del servicio
   - Debe mostrar conexión exitosa a la base de datos

### Paso 5: Desplegar

1. **Primer Despliegue**
   - Haz clic en **"Create Web Service"**
   - Render construirá y desplegará automáticamente
   - Obtendrás una URL: `https://probador-backend.onrender.com`

2. **Auto-Deploy**
   - Cada push a la rama configurada desplegará automáticamente
   - Puedes deshabilitar auto-deploy si prefieres despliegues manuales

### Paso 6: Configurar Health Checks

Render verificará automáticamente el endpoint `/health`. Asegúrate de que esté implementado en tu backend.

---

## Despliegue del Servicio de IA en Render

### Paso 1: Preparar el Proyecto

1. **Verificar `run_api.py` o crear script de inicio:**
   ```python
   import uvicorn
   
   if __name__ == "__main__":
       uvicorn.run("src.api:app", host="0.0.0.0", port=8000)
   ```

2. **Crear `requirements.txt` o usar `pyproject.toml`**

### Paso 2: Crear Web Service en Render

1. **Crear Nuevo Web Service**
   - Haz clic en **"New +"** → **"Web Service"**
   - Conecta tu repositorio

2. **Configurar el Servicio**
   - **Name**: `probador-ai-service`
   - **Environment**: `Python 3`
   - **Region**: Misma región que el backend (recomendado)
   - **Branch**: `main`
   - **Root Directory**: `python`
   - **Build Command**: `pip install -e .` o `pip install -r requirements.txt`
   - **Start Command**: `python run_api.py` o `uvicorn src.api:app --host 0.0.0.0 --port $PORT`

### Paso 3: Configurar Variables de Entorno

```env
GEMINI_API_KEY=tu_gemini_api_key
HOST=0.0.0.0
PORT=8000
PYTHON_VERSION=3.11
```

### Paso 4: Desplegar

1. **Crear el Servicio**
   - Render construirá y desplegará automáticamente
   - URL: `https://probador-ai-service.onrender.com`

2. **Verificar Health Check**
   - Render verificará `/health`
   - Asegúrate de que esté implementado

---

## Configuración de Base de Datos (Supabase)

### Paso 1: Crear Proyecto en Supabase

1. Visita [supabase.com](https://supabase.com)
2. Crea un nuevo proyecto
3. Anota las credenciales:
   - Database URL
   - API URL
   - Anon Key
   - Service Role Key

### Paso 2: Configurar Base de Datos

1. **Ejecutar Migraciones**
   ```bash
   cd backend
   npx prisma migrate deploy
   ```

2. **O desde Supabase Dashboard**
   - Ve a **SQL Editor**
   - Ejecuta las migraciones manualmente

### Paso 3: Configurar Storage (Opcional)

Si usas Supabase Storage para imágenes:

1. Ve a **Storage** en Supabase
2. Crea un bucket (ej: `product-images`)
3. Configura políticas de acceso

---

## Variables de Entorno

### Resumen de Variables por Servicio

#### Frontend (Vercel)
```env
VITE_API_URL=https://probador-backend.onrender.com
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=xxx
```

#### Backend (Render)
```env
NODE_ENV=production
PORT=10000
DATABASE_URL=postgresql://...
JWT_SECRET=xxx
JWT_EXPIRES_IN=7d
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_KEY=xxx
AI_SERVICE_URL=https://probador-ai-service.onrender.com
```

#### Servicio de IA (Render)
```env
GEMINI_API_KEY=xxx
HOST=0.0.0.0
PORT=8000
```

---

## Configuración de Dominio

### Frontend (Vercel)

1. En Vercel, ve a **Settings** → **Domains**
2. Agrega tu dominio
3. Configura los registros DNS según las instrucciones
4. Espera la verificación (puede tardar hasta 24 horas)

### Backend (Render)

1. En Render, ve a **Settings** → **Custom Domain**
2. Agrega tu dominio
3. Configura los registros DNS
4. Render proporcionará un certificado SSL automáticamente

---

## CI/CD y Auto-Deploy

### Vercel

- **Auto-Deploy**: Habilitado por defecto
- **Preview Deployments**: Cada PR genera un preview
- **Production Deployments**: Push a `main` despliega a producción

### Render

- **Auto-Deploy**: Habilitado por defecto
- **Manual Deploy**: Puedes desplegar manualmente desde el dashboard
- **Rollback**: Disponible desde el historial de deployments

### Configuración Recomendada

1. **Rama de Producción**: `main` o `production`
2. **Rama de Desarrollo**: `develop` (con preview deployments)
3. **Protección de Rama**: Protege `main` con requerimientos de PR

---

## Verificación Post-Despliegue

### Checklist de Verificación

#### Frontend
- [ ] La aplicación carga correctamente
- [ ] Las rutas funcionan
- [ ] Las imágenes se cargan
- [ ] El tema claro/oscuro funciona
- [ ] La conexión con el backend funciona

#### Backend
- [ ] Health check responde: `GET /health`
- [ ] Status check responde: `GET /health/status`
- [ ] Endpoints de autenticación funcionan
- [ ] Endpoints de productos funcionan
- [ ] Conexión a base de datos funciona

#### Servicio de IA
- [ ] Health check responde: `GET /health`
- [ ] Endpoint de probador virtual funciona
- [ ] Procesamiento de imágenes funciona
- [ ] Conexión con Gemini API funciona

#### Integración
- [ ] Frontend se conecta al backend
- [ ] Backend se conecta al servicio de IA
- [ ] Todos los servicios se conectan a Supabase
- [ ] El probador virtual funciona end-to-end

### Comandos de Verificación

```bash
# Frontend
curl https://tu-frontend.vercel.app

# Backend Health
curl https://tu-backend.render.com/health

# Backend Status
curl https://tu-backend.render.com/health/status

# AI Service Health
curl https://tu-ai-service.render.com/health
```

---

## Troubleshooting

### Problema: Frontend no se conecta al Backend

**Solución:**
1. Verifica `VITE_API_URL` en Vercel
2. Verifica CORS en el backend
3. Revisa los logs de Vercel y Render

### Problema: Backend no se conecta a la Base de Datos

**Solución:**
1. Verifica `DATABASE_URL` en Render
2. Verifica que Supabase permita conexiones externas
3. Revisa los logs de Render

### Problema: Servicio de IA no responde

**Solución:**
1. Verifica `GEMINI_API_KEY`
2. Revisa los logs de Render
3. Verifica que el servicio esté activo (Render puede suspender servicios gratuitos)

### Problema: Build Falla en Vercel

**Solución:**
1. Verifica que el build funciona localmente
2. Revisa los logs de build en Vercel
3. Verifica las variables de entorno

### Problema: Build Falla en Render

**Solución:**
1. Verifica los logs de build
2. Asegúrate de que `package.json` tenga los scripts correctos
3. Verifica que todas las dependencias estén en `package.json`

### Problema: Servicios se Suspenden (Plan Gratuito de Render)

**Solución:**
- Render suspende servicios gratuitos después de 15 minutos de inactividad
- Considera usar un servicio de ping para mantenerlos activos
- O actualiza a un plan de pago

---

## Mejores Prácticas

1. **Variables de Entorno**
   - Nunca commitees archivos `.env`
   - Usa diferentes valores para desarrollo y producción
   - Rota las claves regularmente

2. **Seguridad**
   - Usa HTTPS siempre
   - Configura CORS correctamente
   - Protege endpoints sensibles

3. **Monitoreo**
   - Configura alertas en Render y Vercel
   - Monitorea los logs regularmente
   - Usa el endpoint `/health/status` para monitoreo

4. **Backups**
   - Configura backups automáticos en Supabase
   - Mantén backups de la base de datos

5. **Performance**
   - Optimiza imágenes antes de subirlas
   - Usa CDN para assets estáticos
   - Implementa caching donde sea posible

---

## Recursos Adicionales

- [Documentación de Vercel](https://vercel.com/docs)
- [Documentación de Render](https://render.com/docs)
- [Documentación de Supabase](https://supabase.com/docs)
- [Guía de Monitoreo](MONITOREO_RENDIMIENTO.md)

---

**Última actualización:** 2025  
**Versión de la Guía:** 1.0

