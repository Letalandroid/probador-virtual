# Probador Virtual con IA - Sistema de Tienda de Ropa

## 📋 Información del Proyecto

**Versión:** 1.0  
**Fecha:** 2025  
**Autor:** Carlos Moran Mauricio

---

## 🚀 Instrucciones para Abrir el Sistema

### Requisitos Previos

Antes de iniciar el sistema, asegúrese de tener instalado:

- **Node.js** (versión 18 o superior)
- **PostgreSQL** (versión 15 o superior)
- **Python** (versión 3.9 o superior)
- **npm** o **yarn**

### Pasos para Iniciar el Sistema

#### 1. Configurar la Base de Datos

1. Cree una base de datos PostgreSQL:
   ```bash
   createdb probador
   ```

2. Importe el archivo SQL de la base de datos:
   ```bash
   psql -d probador -f backend/prisma/probador.sql
   ```

3. Actualice las contraseñas de los usuarios de prueba:
   ```bash
   cd backend
   npm install
   node update-passwords.js
   ```

#### 2. Configurar el Backend

1. Navegue a la carpeta del backend:
   ```bash
   cd backend
   ```

2. Instale las dependencias:
   ```bash
   npm install
   ```

3. Configure las variables de entorno en el archivo `.env`:
   ```env
   DATABASE_URL="postgresql://usuario:contraseña@localhost:5432/probador"
   JWT_SECRET="tu-secret-key-aqui"
   PORT=3000
   ```

4. Inicie el servidor backend:
   ```bash
   npm run start:dev
   ```

El backend estará disponible en: `http://localhost:3000`

#### 3. Configurar el Servicio de IA (Python)

1. Navegue a la carpeta de Python:
   ```bash
   cd python
   ```

2. Cree un entorno virtual:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # En Windows: venv\Scripts\activate
   ```

3. Instale las dependencias:
   ```bash
   pip install -r requirements.txt
   ```

4. Inicie el servicio de IA:
   ```bash
   python main.py
   ```

El servicio de IA estará disponible en: `http://localhost:8000`

#### 4. Configurar el Frontend

1. Navegue a la carpeta del frontend:
   ```bash
   cd frontend
   ```

2. Instale las dependencias:
   ```bash
   npm install
   ```

3. Configure las variables de entorno en el archivo `.env`:
   ```env
   VITE_API_URL=http://localhost:3000
   VITE_AI_SERVICE_URL=http://localhost:8000
   ```

4. Inicie el servidor de desarrollo:
   ```bash
   npm run dev
   ```

El frontend estará disponible en: `http://localhost:5173` (o el puerto que Vite asigne)

---

## 🔐 Credenciales de Acceso

### Usuario Administrador

**Email:** `admin@probador.com`  
**Contraseña:** `admin123`

**Permisos:**
- Acceso completo al panel de administración
- Gestión de productos, categorías y usuarios
- Visualización de reportes y estadísticas
- Monitoreo del estado de servicios

### Usuario Cliente

**Email:** `cliente@probador.com`  
**Contraseña:** `cliente123`

**Permisos:**
- Explorar el catálogo de productos
- Usar el probador virtual con IA
- Realizar compras
- Gestionar su perfil personal

---

## ⚠️ Notas Importantes

1. **Seguridad:** Estas credenciales son solo para pruebas. **Cambie las contraseñas inmediatamente** en un entorno de producción.

2. **Base de Datos:** El archivo `backend/prisma/probador.sql` contiene datos de ejemplo. Todas las tablas tienen al menos 25 registros para pruebas.

3. **Servicios:** Asegúrese de que todos los servicios (Backend, Frontend y Python) estén ejecutándose antes de usar la aplicación.

4. **Puertos:** Si los puertos por defecto están ocupados, puede cambiarlos en los archivos de configuración correspondientes.

---

## 📊 Datos de Prueba

La base de datos incluye:

- **25 Categorías** de productos
- **25 Productos** con información completa
- **25 Usuarios** registrados
- **25 Perfiles** de usuario
- **25 Órdenes** de ejemplo
- **25 Items de Orden** asociados
- **25 Visualizaciones de Productos**
- **25 Sesiones de Probador Virtual**

---

## 🛠️ Solución de Problemas

### Error al conectar con la base de datos

- Verifique que PostgreSQL esté ejecutándose
- Confirme que las credenciales en `.env` sean correctas
- Asegúrese de que la base de datos `probador` exista

### Error al iniciar el backend

- Verifique que todas las dependencias estén instaladas: `npm install`
- Confirme que el puerto 3000 esté disponible
- Revise los logs para más detalles

### Error al iniciar el servicio de IA

- Asegúrese de que Python 3.9+ esté instalado
- Active el entorno virtual antes de ejecutar
- Verifique que todas las dependencias estén instaladas

### Error al iniciar el frontend

- Verifique que las variables de entorno estén configuradas
- Confirme que el backend esté ejecutándose
- Revise la consola del navegador para errores

---

## 📞 Soporte

Para más información o asistencia técnica, consulte la documentación técnica del proyecto o contacte al equipo de desarrollo.

---

## 📝 Changelog

### Versión 1.0 (2025)
- Sistema completo de probador virtual con IA
- Panel de administración
- Catálogo de productos
- Sistema de autenticación
- Gestión de órdenes y usuarios

---

**Última actualización:** 2025  
**Versión del Sistema:** 1.0
