# Guía Técnica
## Probador Virtual con IA - Arquitectura y Desarrollo

**Versión:** 1.0  
**Fecha:** 2025  
**Autor:** Carlos Moran Mauricio

---

## Tabla de Contenidos

1. [Arquitectura del Sistema](#arquitectura-del-sistema)
2. [Stack Tecnológico](#stack-tecnológico)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [Configuración del Entorno de Desarrollo](#configuración-del-entorno-de-desarrollo)
5. [Base de Datos](#base-de-datos)
6. [APIs y Endpoints](#apis-y-endpoints)
7. [Autenticación y Autorización](#autenticación-y-autorización)
8. [Integración con Servicios Externos](#integración-con-servicios-externos)
9. [Desarrollo Frontend](#desarrollo-frontend)
10. [Desarrollo Backend](#desarrollo-backend)
11. [Servicio de IA (Python)](#servicio-de-ia-python)
12. [Testing](#testing)
13. [Despliegue](#despliegue)
14. [Mantenimiento y Monitoreo](#mantenimiento-y-monitoreo)

---

## Arquitectura del Sistema

### Arquitectura General

El sistema sigue una arquitectura de **microservicios** con tres componentes principales:

```
┌─────────────────┐
│   Frontend       │
│   (React/Vite)   │
│   Vercel         │
└────────┬─────────┘
         │ HTTP/HTTPS
         │
┌────────▼─────────┐
│   Backend API    │
│   (NestJS)       │
│   Render         │
└────────┬─────────┘
         │
    ┌────┴────┐
    │        │
┌───▼───┐ ┌─▼──────────┐
│  DB   │ │  AI Service │
│(Supabase│ │  (Python)  │
│PostgreSQL│ │  Render   │
└────────┘ └────────────┘
```

### Componentes Principales

1. **Frontend (React + Vite)**
   - Interfaz de usuario
   - Gestión de estado con React Context
   - Comunicación con backend mediante Axios
   - Desplegado en Vercel

2. **Backend API (NestJS)**
   - API RESTful
   - Autenticación JWT
   - Gestión de usuarios, productos, categorías
   - Generación de reportes
   - Desplegado en Render

3. **Servicio de IA (Python FastAPI)**
   - Procesamiento de imágenes con Google Gemini
   - Detección de torso humano
   - Superposición de prendas
   - Desplegado en Render

4. **Base de Datos (PostgreSQL - Supabase)**
   - Almacenamiento de datos
   - Gestión mediante Prisma ORM

---

## Stack Tecnológico

### Frontend

- **Framework**: React 18.3.1
- **Build Tool**: Vite 5.4.19
- **Lenguaje**: TypeScript 5.8.3
- **UI Library**: Shadcn UI (Radix UI)
- **Estilos**: Tailwind CSS 3.4.17
- **Routing**: React Router DOM 6.30.1
- **State Management**: React Context API, TanStack Query
- **HTTP Client**: Axios 1.7.9
- **Formularios**: React Hook Form 7.63.0 + Zod 4.1.11
- **Temas**: next-themes 0.3.0
- **Notificaciones**: Sonner 1.7.4

### Backend

- **Framework**: NestJS 11.0.1
- **Lenguaje**: TypeScript 5.7.3
- **ORM**: Prisma 6.16.2
- **Base de Datos**: PostgreSQL (Supabase)
- **Autenticación**: JWT (@nestjs/jwt)
- **Validación**: class-validator, class-transformer
- **Documentación**: Swagger (@nestjs/swagger)
- **PDF Generation**: PDFKit 0.15.2
- **Storage**: Supabase Storage

### Servicio de IA

- **Framework**: FastAPI
- **Lenguaje**: Python 3.11+
- **IA**: Google Gemini API
- **Procesamiento de Imágenes**: PIL/Pillow
- **HTTP Client**: httpx

### Infraestructura

- **Frontend Hosting**: Vercel
- **Backend Hosting**: Render
- **Base de Datos**: Supabase (PostgreSQL)
- **Storage**: Supabase Storage
- **CI/CD**: Git + Vercel/Render auto-deploy

---

## Estructura del Proyecto

### Estructura General

```
probador_virtual/
├── frontend/              # Aplicación React
│   ├── src/
│   │   ├── components/    # Componentes reutilizables
│   │   ├── pages/        # Páginas/vistas
│   │   ├── hooks/        # Custom hooks
│   │   ├── lib/          # Utilidades y servicios
│   │   ├── contexts/     # Context providers
│   │   ├── types/        # TypeScript types
│   │   └── assets/       # Imágenes y recursos
│   ├── public/           # Archivos estáticos
│   └── package.json
│
├── backend/              # API NestJS
│   ├── src/
│   │   ├── auth/        # Módulo de autenticación
│   │   ├── users/        # Módulo de usuarios
│   │   ├── products/     # Módulo de productos
│   │   ├── categories/   # Módulo de categorías
│   │   ├── reports/      # Módulo de reportes
│   │   ├── ai/           # Integración con IA
│   │   ├── guards/       # Guards de autenticación
│   │   └── prisma.service.ts
│   ├── prisma/
│   │   ├── schema.prisma # Esquema de base de datos
│   │   └── migrations/   # Migraciones
│   └── package.json
│
└── python/               # Servicio de IA
    ├── src/
    │   ├── api.py        # API FastAPI
    │   ├── models.py     # Modelos Pydantic
    │   ├── torso_detection.py
    │   ├── clothing_overlay.py
    │   └── mix_images.py
    └── pyproject.toml
```

### Frontend - Estructura Detallada

```
frontend/src/
├── components/
│   ├── ui/               # Componentes Shadcn UI
│   ├── Header.tsx
│   ├── Footer.tsx
│   ├── ProductGrid.tsx
│   ├── CategoryGrid.tsx
│   └── ...
├── pages/
│   ├── Home.tsx
│   ├── Products.tsx
│   ├── ProductDetail.tsx
│   ├── VirtualTryOn.tsx
│   ├── Admin.tsx
│   └── ...
├── hooks/
│   ├── useProducts.ts
│   ├── useCategories.ts
│   ├── useServiceStatus.ts
│   └── ...
├── lib/
│   ├── api.ts              # ApiService principal
│   └── utils.ts
├── contexts/
│   ├── AuthContext.tsx
│   └── ...
└── types/
    └── index.ts
```

### Backend - Estructura Detallada

```
backend/src/
├── auth/
│   ├── auth.controller.ts
│   ├── auth.service.ts
│   └── auth.module.ts
├── users/
│   ├── users.controller.ts
│   ├── users.service.ts
│   └── users.module.ts
├── products/
│   ├── products.controller.ts
│   ├── products.service.ts
│   └── products.module.ts
├── categories/
│   ├── categories.controller.ts
│   ├── categories.service.ts
│   └── categories.module.ts
├── reports/
│   ├── reports.controller.ts
│   ├── reports.service.ts
│   └── reports.module.ts
├── ai/
│   ├── ai.controller.ts
│   ├── ai.service.ts
│   └── ai.module.ts
├── guards/
│   ├── auth.guard.ts
│   └── roles.guard.ts
├── decorators/
│   └── roles.decorator.ts
└── app.module.ts
```

---

## Configuración del Entorno de Desarrollo

### Requisitos Previos

- **Node.js**: 18.x o superior
- **npm/pnpm**: Gestor de paquetes
- **Python**: 3.11 o superior
- **PostgreSQL**: 14+ (o cuenta de Supabase)
- **Git**: Control de versiones

### Configuración Frontend

```bash
# Clonar el repositorio
git clone [url-del-repositorio]
cd probador_virtual/frontend

# Instalar dependencias
npm install
# o
pnpm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con las variables necesarias

# Ejecutar en desarrollo
npm run dev
# o
pnpm dev
```

**Variables de Entorno Frontend:**
```env
VITE_API_URL=http://localhost:3000
VITE_SUPABASE_URL=tu_supabase_url
VITE_SUPABASE_ANON_KEY=tu_supabase_anon_key
```

### Configuración Backend

```bash
cd backend

# Instalar dependencias
npm install
# o
pnpm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env

# Generar cliente Prisma
npx prisma generate

# Ejecutar migraciones
npx prisma migrate dev

# (Opcional) Poblar base de datos
npm run prisma:seed

# Ejecutar en desarrollo
npm run start:dev
```

**Variables de Entorno Backend:**
```env
DATABASE_URL=postgresql://user:password@host:port/database
JWT_SECRET=tu_jwt_secret_muy_seguro
JWT_EXPIRES_IN=7d
SUPABASE_URL=tu_supabase_url
SUPABASE_KEY=tu_supabase_service_key
AI_SERVICE_URL=http://localhost:8000
PORT=3000
NODE_ENV=development
```

### Configuración Servicio de IA

```bash
cd python

# Crear entorno virtual
python -m venv env
source env/bin/activate  # Linux/Mac
# o
env\Scripts\activate  # Windows

# Instalar dependencias
pip install -e .
# o con uv
uv sync

# Configurar variables de entorno
cp env.example .env
# Editar .env

# Ejecutar servidor
python run_api.py
# o
uvicorn src.api:app --reload
```

**Variables de Entorno Python:**
```env
GEMINI_API_KEY=tu_gemini_api_key
HOST=0.0.0.0
PORT=8000
RELOAD=true
```

---

## Base de Datos

### Esquema Principal (Prisma)

El esquema de base de datos está definido en `backend/prisma/schema.prisma`.

#### Modelos Principales

**User**
- Información de usuarios
- Roles: `admin`, `client`
- Relación con `UserProfile`

**UserProfile**
- Perfil extendido del usuario
- Información de contacto y dirección

**Category**
- Categorías de productos
- Campo `isActive` para soft delete

**Product**
- Información de productos
- Relación con `Category`
- Campos: nombre, descripción, precio, stock, etc.

**Order** (si está implementado)
- Órdenes de compra
- Relación con `User` y `OrderItem`

### Migraciones

```bash
# Crear nueva migración
npx prisma migrate dev --name nombre_migracion

# Aplicar migraciones en producción
npx prisma migrate deploy

# Generar cliente Prisma
npx prisma generate
```

### Seed de Datos

```bash
# Ejecutar seed
npm run prisma:seed
```

---

## APIs y Endpoints

### Backend API (NestJS)

**Base URL**: `http://localhost:3000` (desarrollo)

#### Autenticación

- `POST /auth/register` - Registro de usuario
- `POST /auth/login` - Inicio de sesión
- `GET /auth/profile` - Obtener perfil (requiere autenticación)

#### Productos

- `GET /products` - Listar productos (con paginación y filtros)
- `GET /products/:id` - Obtener producto por ID
- `POST /products` - Crear producto (requiere admin)
- `PUT /products/:id` - Actualizar producto (requiere admin)
- `DELETE /products/:id` - Eliminar producto (requiere admin)

#### Categorías

- `GET /categories` - Listar categorías
- `GET /categories/:id` - Obtener categoría por ID
- `POST /categories` - Crear categoría (requiere admin)
- `PUT /categories/:id` - Actualizar categoría (requiere admin)
- `DELETE /categories/:id` - Eliminar categoría (requiere admin)

#### Usuarios

- `GET /users` - Listar usuarios (requiere admin)
- `GET /users/:id` - Obtener usuario (requiere admin)
- `PUT /users/:id` - Actualizar usuario (requiere admin)
- `DELETE /users/:id` - Eliminar usuario (requiere admin)
- `GET /users/profile/me` - Obtener perfil propio
- `PUT /users/profile/me` - Actualizar perfil propio

#### Reportes

- `GET /reports/sales` - Reporte de ventas (requiere admin)
- `GET /reports/product-movements` - Movimientos de productos (requiere admin)
- `GET /reports/sales/pdf` - Reporte de ventas en PDF (requiere admin)
- `GET /reports/product-movements/pdf` - Movimientos en PDF (requiere admin)

#### Health Check

- `GET /health` - Health check básico
- `GET /health/status` - Estado detallado de servicios

### Servicio de IA (Python FastAPI)

**Base URL**: `http://localhost:8000` (desarrollo)

- `GET /health` - Health check
- `POST /detect-torso` - Detectar torso en imagen
- `POST /virtual-try-on` - Aplicar prenda virtualmente
- `POST /analyze-clothing-fit` - Analizar ajuste
- `POST /generate-multiple-angles` - Generar múltiples ángulos
- `POST /enhance-image` - Mejorar imagen
- `POST /mix-images` - Mezclar imágenes

**Documentación**: `http://localhost:8000/docs` (Swagger UI)

---

## Autenticación y Autorización

### JWT (JSON Web Tokens)

El sistema utiliza JWT para autenticación:

1. **Registro/Login**: El usuario se autentica y recibe un token JWT
2. **Almacenamiento**: El token se guarda en `localStorage` (frontend)
3. **Envío**: El token se envía en el header `Authorization: Bearer <token>`
4. **Validación**: El backend valida el token en cada request protegido

### Guards

- **AuthGuard**: Verifica que el usuario esté autenticado
- **RolesGuard**: Verifica que el usuario tenga el rol necesario (admin)

### Decoradores

- `@UseGuards(AuthGuard)`: Protege endpoint con autenticación
- `@Roles('admin')`: Requiere rol de administrador
- `@UseGuards(AuthGuard, RolesGuard)`: Combina ambos

---

## Integración con Servicios Externos

### Supabase

- **Base de Datos**: PostgreSQL alojado
- **Storage**: Almacenamiento de imágenes
- **Configuración**: Variables de entorno `SUPABASE_URL` y `SUPABASE_KEY`

### Google Gemini API

- **Servicio de IA**: Procesamiento de imágenes
- **Configuración**: Variable `GEMINI_API_KEY`
- **Uso**: Integrado en el servicio Python

---

## Desarrollo Frontend

### Componentes

Los componentes están organizados en:
- `components/ui/`: Componentes base de Shadcn UI
- `components/`: Componentes específicos de la aplicación

### Hooks Personalizados

- `useProducts`: Gestión de productos
- `useCategories`: Gestión de categorías
- `useServiceStatus`: Estado de servicios
- `useAuth`: Autenticación y usuario actual

### Context API

- `AuthContext`: Estado de autenticación global
- `ThemeProvider`: Gestión de temas (claro/oscuro)

### Routing

Las rutas están definidas en `App.tsx`:
- `/` - Home
- `/productos` - Catálogo
- `/productos/:id` - Detalle de producto
- `/probador-virtual` - Probador virtual
- `/admin` - Panel de administración
- `/auth` - Autenticación

---

## Desarrollo Backend

### Módulos NestJS

Cada módulo sigue la estructura:
- `*.controller.ts`: Endpoints HTTP
- `*.service.ts`: Lógica de negocio
- `*.module.ts`: Configuración del módulo
- `dto/`: Data Transfer Objects para validación

### Servicios

- `PrismaService`: Cliente Prisma para acceso a BD
- `AuthService`: Lógica de autenticación
- `ProductsService`: Lógica de productos
- `AiService`: Integración con servicio de IA

### Validación

Se utiliza `class-validator` para validar DTOs:

```typescript
export class CreateProductDto {
  @IsString()
  @MinLength(2)
  name: string;

  @IsNumber()
  @Min(0)
  price: number;
}
```

---

## Servicio de IA (Python)

### Estructura

- `api.py`: Aplicación FastAPI principal
- `models.py`: Modelos Pydantic
- `torso_detection.py`: Detección de torso
- `clothing_overlay.py`: Superposición de prendas
- `mix_images.py`: Mezcla de imágenes

### Procesamiento de Imágenes

1. **Recepción**: Imagen del usuario y prenda
2. **Detección**: Detección de torso humano
3. **Procesamiento**: Superposición con IA
4. **Generación**: Imagen resultante
5. **Respuesta**: Imagen base64 o URL

---

## Testing

### Frontend

```bash
# Ejecutar tests
npm test

# Tests en modo watch
npm run test:watch

# Coverage
npm run test:coverage
```

### Backend

```bash
# Tests unitarios
npm test

# Tests e2e
npm run test:e2e

# Coverage
npm run test:cov
```

### Python

```bash
# Ejecutar tests
pytest

# Con coverage
pytest --cov=src
```

---

## Despliegue

Ver documento `DESPLIEGUE_NUBE.md` para detalles completos.

### Resumen

- **Frontend**: Vercel (auto-deploy desde Git)
- **Backend**: Render (Web Service)
- **Python API**: Render (Web Service)
- **Base de Datos**: Supabase (PostgreSQL)

---

## Mantenimiento y Monitoreo

### Logs

- **Frontend**: Logs en consola del navegador
- **Backend**: Logs en Render dashboard
- **Python**: Logs en Render dashboard

### Monitoreo

- Health checks: `/health` y `/health/status`
- Métricas de Render
- Logs de errores

Ver documento `MONITOREO_RENDIMIENTO.md` para más detalles.

---

## Recursos Adicionales

- [Documentación NestJS](https://docs.nestjs.com/)
- [Documentación React](https://react.dev/)
- [Documentación Prisma](https://www.prisma.io/docs)
- [Documentación FastAPI](https://fastapi.tiangolo.com/)
- [Documentación Vercel](https://vercel.com/docs)
- [Documentación Render](https://render.com/docs)

---

**Última actualización:** 2025  
**Versión de la Guía:** 1.0

