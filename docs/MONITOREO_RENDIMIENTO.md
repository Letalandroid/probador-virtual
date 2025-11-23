# Monitoreo de Rendimiento y Corrección de Fallas
## Probador Virtual con IA - Sistema de Monitoreo

**Versión:** 1.0  
**Fecha:** 2025  
**Autor:** Carlos Moran Mauricio

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Arquitectura de Monitoreo](#arquitectura-de-monitoreo)
3. [Health Checks Implementados](#health-checks-implementados)
4. [Monitoreo del Frontend](#monitoreo-del-frontend)
5. [Monitoreo del Backend](#monitoreo-del-backend)
6. [Monitoreo del Servicio de IA](#monitoreo-del-servicio-de-ia)
7. [Monitoreo de Base de Datos](#monitoreo-de-base-de-datos)
8. [Métricas y KPIs](#métricas-y-kpis)
9. [Alertas y Notificaciones](#alertas-y-notificaciones)
10. [Corrección de Fallas](#corrección-de-fallas)
11. [Logs y Debugging](#logs-y-debugging)
12. [Mejores Prácticas](#mejores-prácticas)

---

## Introducción

Este documento describe el sistema de monitoreo implementado para el **Probador Virtual con IA**, incluyendo health checks, métricas de rendimiento, alertas y procedimientos para la corrección de fallas.

### Objetivos del Monitoreo

- **Detección Temprana**: Identificar problemas antes de que afecten a los usuarios
- **Disponibilidad**: Asegurar que todos los servicios estén operativos
- **Rendimiento**: Monitorear tiempos de respuesta y uso de recursos
- **Errores**: Detectar y registrar errores para su análisis
- **Escalabilidad**: Identificar cuellos de botella y necesidades de escalado

---

## Arquitectura de Monitoreo

```
┌─────────────────────────────────────────────────────────┐
│              SISTEMA DE MONITOREO                        │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
┌───────▼──────┐  ┌───────▼──────┐  ┌───────▼──────┐
│   Frontend   │  │   Backend    │  │  AI Service  │
│   (Vercel)   │  │   (Render)   │  │   (Render)   │
│              │  │              │  │              │
│  - Analytics │  │ - Health    │  │ - Health     │
│  - Errors    │  │   Checks     │  │   Checks     │
│  - Logs      │  │ - Metrics    │  │ - Metrics    │
│              │  │ - Logs       │  │ - Logs       │
└───────┬──────┘  └───────┬──────┘  └───────┬──────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
                  ┌───────▼──────┐
                  │   Supabase   │
                  │  PostgreSQL  │
                  │  - Metrics   │
                  │  - Logs      │
                  └──────────────┘
```

---

## Health Checks Implementados

### Endpoint de Health Check Básico

**Backend**: `GET /health`

```json
{
  "status": "ok",
  "timestamp": "2025-01-20T10:30:00.000Z"
}
```

**Propósito**: Verificación rápida de que el servicio está activo.

### Endpoint de Status Detallado

**Backend**: `GET /health/status`

```json
{
  "status": "active",
  "services": {
    "backend": true,
    "database": true,
    "aiService": true
  },
  "responseTime": 245,
  "timestamp": "2025-01-20T10:30:00.000Z"
}
```

**Propósito**: Verificación detallada del estado de todos los servicios.

**Estados Posibles**:
- `active`: Todos los servicios funcionan correctamente
- `degraded`: Algunos servicios tienen problemas
- `timeout`: La verificación excedió el tiempo límite (3 segundos)

### Health Check del Servicio de IA

**Python API**: `GET /health`

```json
{
  "status": "healthy",
  "gemini_api": "connected",
  "timestamp": "2025-01-20T10:30:00.000Z"
}
```

---

## Monitoreo del Frontend

### Métricas Disponibles en Vercel

1. **Analytics**
   - Visitas y usuarios únicos
   - Páginas más visitadas
   - Tiempo en página
   - Tasa de rebote

2. **Performance**
   - Tiempo de carga (LCP, FID, CLS)
   - Tamaño de bundle
   - Tiempo de build

3. **Errores**
   - Errores de JavaScript
   - Errores de red
   - Errores de build

### Componente de Monitoreo en la Aplicación

**Componente**: `ServiceStatus.tsx`

**Ubicación**: Panel de Administración → Pestaña "Estado"

**Funcionalidades**:
- Muestra el estado de todos los servicios
- Actualización automática cada 15 segundos
- Botón de actualización manual
- Indicadores visuales (verde/rojo)
- Tiempo de respuesta
- Última verificación

**Uso**:
```typescript
import { useServiceStatus } from '@/hooks/useServiceStatus';

const { status, isLoading, error, refetch } = useServiceStatus();
```

### Monitoreo de Errores en el Frontend

**Implementación**:
- Try-catch blocks en operaciones críticas
- Error boundaries en React
- Logging de errores a consola
- Notificaciones al usuario con `toast`

**Ejemplo**:
```typescript
try {
  const result = await apiService.virtualTryOn(data);
  // Procesar resultado
} catch (error) {
  console.error('Error en probador virtual:', error);
  toast.error('Error al procesar la imagen. Intenta nuevamente.');
}
```

---

## Monitoreo del Backend

### Métricas Disponibles en Render

1. **CPU y Memoria**
   - Uso de CPU (%)
   - Uso de memoria (MB)
   - Picos de uso

2. **Red**
   - Requests por segundo
   - Latencia promedio
   - Ancho de banda

3. **Logs**
   - Logs de aplicación
   - Logs de errores
   - Logs de build

### Health Checks Implementados

#### Endpoint Básico
```typescript
@Get('health')
getHealth(): { status: string; timestamp: string } {
  return {
    status: 'ok',
    timestamp: new Date().toISOString(),
  };
}
```

#### Endpoint Detallado
```typescript
@Get('health/status')
async getServiceStatus() {
  // Verifica backend, base de datos y servicio de IA
  // Timeout de 3 segundos
  // Retorna estado detallado
}
```

### Monitoreo de Base de Datos

**Verificación**:
- Query simple: `SELECT 1`
- Timeout de 2.5 segundos
- Retorna `true` si la conexión es exitosa

**Optimizaciones Implementadas**:
- Eliminación de queries redundantes
- Uso de `select` en lugar de `include` cuando es posible
- `Promise.all` para queries paralelas
- Transacciones para operaciones atómicas

### Logs del Backend

**Niveles de Log**:
- `INFO`: Operaciones normales
- `WARN`: Advertencias
- `ERROR`: Errores que requieren atención
- `DEBUG`: Información de debugging (solo en desarrollo)

**Ejemplo de Logging**:
```typescript
console.log('Usuario autenticado:', userId);
console.warn('Stock bajo para producto:', productId);
console.error('Error al conectar con servicio de IA:', error);
```

---

## Monitoreo del Servicio de IA

### Health Check

**Endpoint**: `GET /health`

**Verificaciones**:
- Estado del servicio FastAPI
- Conexión con Google Gemini API
- Disponibilidad de recursos

### Métricas de Rendimiento

1. **Tiempo de Procesamiento**
   - Tiempo promedio de procesamiento de imágenes
   - Tiempo máximo aceptable: 15 segundos

2. **Tasa de Éxito**
   - Porcentaje de requests exitosos
   - Tasa de errores

3. **Uso de API de Gemini**
   - Requests por minuto
   - Límites de cuota

### Logs del Servicio de IA

**Información Registrada**:
- Requests recibidos
- Tiempo de procesamiento
- Errores de procesamiento
- Errores de API de Gemini

---

## Monitoreo de Base de Datos

### Métricas en Supabase

1. **Conexiones**
   - Conexiones activas
   - Conexiones máximas

2. **Queries**
   - Queries por segundo
   - Queries lentas
   - Tiempo promedio de query

3. **Almacenamiento**
   - Tamaño de la base de datos
   - Espacio utilizado

### Optimizaciones Aplicadas

1. **Índices**
   - Índices en campos frecuentemente consultados
   - Índices en foreign keys

2. **Queries Optimizadas**
   - Uso de `select` específico
   - Evitar `N+1` queries
   - Paginación en listados grandes

3. **Conexiones**
   - Pool de conexiones configurado
   - Cierre adecuado de conexiones

---

## Métricas y KPIs

### Métricas Clave de Rendimiento

1. **Disponibilidad**
   - Objetivo: 99.9% uptime
   - Métrica: Tiempo de actividad / Tiempo total

2. **Tiempo de Respuesta**
   - Backend API: < 500ms (p95)
   - Servicio de IA: < 15s (p95)
   - Frontend: < 2s (LCP)

3. **Tasa de Errores**
   - Objetivo: < 1% de requests
   - Métrica: Errores / Total de requests

4. **Throughput**
   - Requests por segundo
   - Usuarios concurrentes

### KPIs del Negocio

1. **Uso del Probador Virtual**
   - Número de pruebas realizadas
   - Tasa de éxito de pruebas
   - Tiempo promedio de procesamiento

2. **Engagement**
   - Productos vistos
   - Productos probados
   - Conversión (si está implementado)

---

## Alertas y Notificaciones

### Alertas en Render

**Configuración**:
1. Ve a **Settings** → **Alerts**
2. Configura alertas para:
   - CPU > 80%
   - Memoria > 80%
   - Errores > 10 en 5 minutos
   - Servicio inactivo

**Notificaciones**:
- Email
- Slack (si está configurado)
- Webhooks

### Alertas en Vercel

**Configuración**:
1. Ve a **Settings** → **Notifications**
2. Configura alertas para:
   - Build failures
   - Deployment failures
   - Errores críticos

### Alertas Personalizadas

**Implementación Recomendada**:
- Monitoreo externo (UptimeRobot, Pingdom)
- Webhooks a servicios de notificación
- Dashboard personalizado

---

## Corrección de Fallas

### Procedimiento General

1. **Identificación**
   - Revisar logs
   - Verificar health checks
   - Identificar el servicio afectado

2. **Diagnóstico**
   - Revisar métricas
   - Analizar logs de errores
   - Verificar variables de entorno

3. **Corrección**
   - Aplicar fix
   - Verificar solución
   - Monitorear estabilidad

4. **Documentación**
   - Registrar el incidente
   - Documentar la solución
   - Actualizar procedimientos

### Fallas Comunes y Soluciones

#### Problema: Backend no responde

**Síntomas**:
- Health check falla
- Frontend no puede conectar
- Timeout en requests

**Soluciones**:
1. Verificar logs en Render
2. Revisar uso de recursos (CPU/Memoria)
3. Verificar variables de entorno
4. Reiniciar el servicio si es necesario
5. Verificar conexión a base de datos

#### Problema: Base de Datos no responde

**Síntomas**:
- Timeout en queries
- Error de conexión
- Health check de BD falla

**Soluciones**:
1. Verificar estado en Supabase Dashboard
2. Revisar conexiones activas
3. Verificar `DATABASE_URL`
4. Revisar logs de Supabase
5. Escalar plan si es necesario

#### Problema: Servicio de IA no responde

**Síntomas**:
- Timeout en probador virtual
- Error 500 en endpoint de IA
- Health check falla

**Soluciones**:
1. Verificar logs en Render
2. Verificar `GEMINI_API_KEY`
3. Verificar cuota de Gemini API
4. Revisar uso de recursos
5. Reiniciar servicio si es necesario

#### Problema: Frontend muestra errores

**Síntomas**:
- Errores en consola del navegador
- Páginas no cargan
- Funcionalidades no funcionan

**Soluciones**:
1. Verificar logs en Vercel
2. Revisar build logs
3. Verificar variables de entorno
4. Limpiar caché del navegador
5. Verificar conexión con backend

#### Problema: Procesamiento de imágenes muy lento

**Síntomas**:
- Tiempo de procesamiento > 30s
- Timeouts frecuentes
- Usuarios reportan lentitud

**Soluciones**:
1. Verificar carga del servicio de IA
2. Optimizar tamaño de imágenes
3. Implementar caché de resultados
4. Escalar servicio si es necesario
5. Revisar cuota de Gemini API

### Procedimiento de Escalación

1. **Nivel 1**: Monitoreo automático detecta problema
2. **Nivel 2**: Revisión manual de logs y métricas
3. **Nivel 3**: Aplicación de fixes básicos
4. **Nivel 4**: Escalación a Carlos Moran Mauricio
5. **Nivel 5**: Escalación a administradores de infraestructura

---

## Logs y Debugging

### Estructura de Logs

**Formato Recomendado**:
```
[Timestamp] [Level] [Service] [Message] [Context]
```

**Ejemplo**:
```
[2025-01-20T10:30:00.000Z] [INFO] [Backend] Usuario autenticado { userId: "123", email: "user@example.com" }
[2025-01-20T10:30:05.000Z] [ERROR] [AI-Service] Error al procesar imagen { error: "Timeout", requestId: "abc123" }
```

### Niveles de Log

- **DEBUG**: Información detallada para debugging
- **INFO**: Información general de operaciones
- **WARN**: Advertencias que no detienen la ejecución
- **ERROR**: Errores que requieren atención
- **FATAL**: Errores críticos que detienen el servicio

### Herramientas de Debugging

1. **Render Logs**
   - Acceso a logs en tiempo real
   - Filtrado por nivel
   - Búsqueda en logs

2. **Vercel Logs**
   - Logs de build
   - Logs de runtime
   - Analytics de errores

3. **Supabase Logs**
   - Logs de queries
   - Logs de autenticación
   - Logs de storage

4. **Browser DevTools**
   - Console logs
   - Network requests
   - Performance profiling

---

## Mejores Prácticas

### Monitoreo Continuo

1. **Revisar métricas diariamente**
2. **Configurar alertas proactivas**
3. **Revisar logs semanalmente**
4. **Analizar tendencias mensualmente**

### Optimización Continua

1. **Identificar cuellos de botella**
2. **Optimizar queries lentas**
3. **Implementar caching donde sea posible**
4. **Escalar recursos cuando sea necesario**

### Documentación

1. **Documentar todos los incidentes**
2. **Mantener runbook actualizado**
3. **Compartir conocimiento con el equipo**
4. **Actualizar procedimientos basados en experiencias**

### Seguridad

1. **No exponer información sensible en logs**
2. **Rotar credenciales regularmente**
3. **Monitorear intentos de acceso no autorizados**
4. **Implementar rate limiting**

### Performance

1. **Monitorear tiempos de respuesta**
2. **Optimizar queries de base de datos**
3. **Implementar lazy loading**
4. **Usar CDN para assets estáticos**

---

## Herramientas Recomendadas

### Monitoreo Externo

- **UptimeRobot**: Monitoreo de uptime
- **Pingdom**: Monitoreo de performance
- **Sentry**: Monitoreo de errores
- **Datadog**: Monitoreo completo (si hay presupuesto)

### Logging

- **Logtail**: Agregación de logs
- **Papertrail**: Logging centralizado
- **Elasticsearch**: Búsqueda y análisis de logs

### Analytics

- **Google Analytics**: Analytics web
- **Vercel Analytics**: Analytics integrado
- **Custom Dashboard**: Dashboard personalizado

---

## Checklist de Monitoreo Diario

- [ ] Verificar health checks de todos los servicios
- [ ] Revisar logs de errores
- [ ] Verificar métricas de CPU y memoria
- [ ] Revisar tiempo de respuesta promedio
- [ ] Verificar tasa de errores
- [ ] Revisar alertas activas
- [ ] Verificar estado de base de datos
- [ ] Revisar uso del probador virtual

---

## Recursos Adicionales

- [Documentación de Render Monitoring](https://render.com/docs/monitoring)
- [Documentación de Vercel Analytics](https://vercel.com/docs/analytics)
- [Documentación de Supabase Monitoring](https://supabase.com/docs/guides/platform/metrics)
- [Guía de Despliegue](DESPLIEGUE_NUBE.md)

---

**Última actualización:** 2025  
**Versión del Documento:** 1.0

