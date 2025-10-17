# 🧪 Guía de Testing - Probador Virtual

Esta guía explica cómo ejecutar y mantener los tests del sistema completo del probador virtual.

## 📋 Resumen de Tests

El sistema incluye tests en tres niveles:

1. **Backend (NestJS)** - Tests unitarios e integración
2. **Frontend (React)** - Tests unitarios e integración
3. **Python (IA)** - Tests unitarios para servicios de IA
4. **Integración Completa** - Tests end-to-end entre todos los servicios

## 🚀 Ejecución Rápida

### Ejecutar todos los tests
```bash
./run-tests.sh
```

### Ejecutar tests individuales

#### Backend
```bash
cd backend
npm test                    # Tests unitarios
npm run test:e2e           # Tests de integración
```

#### Frontend
```bash
cd frontend
npm test                   # Tests unitarios
npm run test:coverage      # Tests con cobertura
```

#### Python (IA)
```bash
cd python
source env/bin/activate    # Activar entorno virtual
pytest tests/ -v          # Tests unitarios
```

## 📁 Estructura de Tests

```
├── backend/
│   ├── src/
│   │   ├── auth/
│   │   │   └── auth.service.spec.ts
│   │   ├── products/
│   │   │   └── products.service.spec.ts
│   │   └── ...
│   └── test/
│       └── integration/
│           └── auth.integration.spec.ts
├── frontend/
│   ├── src/
│   │   ├── lib/__tests__/
│   │   │   └── api.test.ts
│   │   ├── contexts/__tests__/
│   │   │   └── AuthContext.test.tsx
│   │   └── __tests__/integration/
│   │       └── virtual-try-on.integration.test.tsx
│   ├── jest.config.js
│   └── src/setupTests.ts
├── python/
│   └── tests/
│       ├── test_torso_detection.py
│       └── test_clothing_overlay.py
└── run-tests.sh
```

## 🔧 Configuración

### Backend (NestJS)
- **Framework**: Jest + Supertest
- **Cobertura**: Automática con `--coverage`
- **Base de datos**: Mock con Prisma

### Frontend (React)
- **Framework**: Jest + React Testing Library
- **Configuración**: `jest.config.js`
- **Setup**: `src/setupTests.ts`

### Python (IA)
- **Framework**: Pytest + pytest-asyncio
- **Mocking**: unittest.mock
- **Async**: Soporte completo para async/await

## 📊 Cobertura de Tests

### Backend
- ✅ Servicios de autenticación
- ✅ Servicios de productos
- ✅ Controladores de API
- ✅ Integración con base de datos
- ✅ Validación de DTOs

### Frontend
- ✅ Contextos de React (AuthContext)
- ✅ Servicios de API
- ✅ Componentes de UI
- ✅ Hooks personalizados
- ✅ Integración con servicios externos

### Python (IA)
- ✅ Detección de torso
- ✅ Superposición de prendas
- ✅ Análisis de ajuste
- ✅ Generación de múltiples ángulos
- ✅ Mejora de imágenes

## 🧪 Tipos de Tests

### 1. Tests Unitarios
**Propósito**: Probar funciones individuales en aislamiento

```typescript
// Ejemplo: Backend
describe('AuthService', () => {
  it('should validate user credentials', async () => {
    const result = await authService.validateUser(credentials);
    expect(result).toBeDefined();
  });
});
```

### 2. Tests de Integración
**Propósito**: Probar la interacción entre componentes

```typescript
// Ejemplo: Frontend
describe('Virtual Try-On Integration', () => {
  it('should process virtual try-on successfully', async () => {
    // Test completo del flujo de try-on
  });
});
```

### 3. Tests End-to-End
**Propósito**: Probar el flujo completo del sistema

```bash
# Verificar que todos los servicios estén corriendo
curl http://localhost:3000/health  # Backend
curl http://localhost:8000/health  # Python API
curl http://localhost:5173         # Frontend
```

## 🔍 Debugging de Tests

### Backend
```bash
cd backend
npm test -- --verbose
npm test -- --detectOpenHandles
```

### Frontend
```bash
cd frontend
npm test -- --verbose
npm test -- --no-cache
```

### Python
```bash
cd python
pytest tests/ -v -s
pytest tests/ --tb=short
```

## 📈 Métricas de Calidad

### Cobertura Mínima Requerida
- **Backend**: 80%
- **Frontend**: 70%
- **Python**: 75%

### Verificar Cobertura
```bash
# Backend
cd backend && npm run test:coverage

# Frontend
cd frontend && npm run test:coverage

# Python
cd python && pytest tests/ --cov=src --cov-report=html
```

## 🚨 Troubleshooting

### Problemas Comunes

1. **Tests de integración fallan**
   - Verificar que todos los servicios estén corriendo
   - Verificar variables de entorno
   - Verificar conectividad de red

2. **Tests de Python fallan**
   - Verificar que el entorno virtual esté activado
   - Verificar que las dependencias estén instaladas
   - Verificar que la API key de Gemini esté configurada

3. **Tests de Frontend fallan**
   - Verificar que las dependencias estén instaladas
   - Verificar la configuración de Jest
   - Verificar los mocks

### Logs de Debug
```bash
# Ejecutar con logs detallados
DEBUG=* npm test
NODE_ENV=test npm test
```

## 🔄 CI/CD

### GitHub Actions (Ejemplo)
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Backend Tests
        run: cd backend && npm test
      - name: Run Frontend Tests
        run: cd frontend && npm test
      - name: Run Python Tests
        run: cd python && pytest tests/
```

## 📝 Mejores Prácticas

### 1. Naming Convention
- Tests descriptivos: `should return user data when credentials are valid`
- Agrupar por funcionalidad: `describe('AuthService')`
- Usar `it` para casos específicos

### 2. Arrange-Act-Assert
```typescript
it('should create product successfully', async () => {
  // Arrange
  const productData = { name: 'Test', price: 100 };
  
  // Act
  const result = await productService.create(productData);
  
  // Assert
  expect(result).toBeDefined();
  expect(result.name).toBe('Test');
});
```

### 3. Mocking
- Mock servicios externos
- Mock APIs
- Mock base de datos
- Usar factories para datos de prueba

### 4. Async Testing
```typescript
it('should handle async operations', async () => {
  await expect(asyncFunction()).resolves.toBe(expectedValue);
});
```

## 🎯 Próximos Pasos

1. **Aumentar cobertura** de tests
2. **Agregar tests de performance**
3. **Implementar tests visuales** (Storybook)
4. **Agregar tests de accesibilidad**
5. **Implementar tests de carga**

---

**Nota**: Esta guía se actualiza regularmente. Para preguntas específicas, consulta la documentación de cada framework o crea un issue en el repositorio.




