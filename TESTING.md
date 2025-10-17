# Guía de Testing - Proyecto Probador Virtual

## 📋 Resumen

Este documento describe la estrategia completa de testing implementada en el proyecto Probador Virtual, incluyendo pruebas unitarias, de integración y end-to-end para el frontend (React), backend (NestJS) y API de Python.

## 🏗️ Arquitectura de Testing

### Estructura de Directorios

```
probador_virtual/
├── backend/
│   ├── src/
│   │   ├── auth/auth.service.spec.ts          # Pruebas unitarias AuthService
│   │   ├── products/products.service.spec.ts  # Pruebas unitarias ProductsService
│   │   └── guards/auth.guard.spec.ts          # Pruebas unitarias AuthGuard
│   └── test/
│       ├── integration/
│       │   ├── auth.integration.spec.ts       # Pruebas integración auth
│       │   └── python-api.integration.spec.ts # Pruebas integración Python API
│       └── app.e2e-spec.ts                    # Pruebas E2E backend
├── frontend/
│   ├── src/
│   │   ├── hooks/__tests__/
│   │   │   ├── useProducts.test.ts            # Pruebas unitarias useProducts
│   │   │   └── useCategories.test.ts          # Pruebas unitarias useCategories
│   │   ├── contexts/__tests__/
│   │   │   └── AuthContext.test.tsx           # Pruebas unitarias AuthContext
│   │   ├── components/__tests__/
│   │   │   └── SearchBar.test.tsx             # Pruebas unitarias SearchBar
│   │   └── __tests__/integration/
│   │       └── frontend-backend.integration.test.tsx # Pruebas integración frontend-backend
├── test/
│   ├── e2e/
│   │   └── full-system.e2e.spec.ts            # Pruebas E2E completas
│   ├── global-setup.ts                        # Setup global Playwright
│   └── global-teardown.ts                     # Teardown global Playwright
├── run-tests.sh                               # Script para ejecutar todas las pruebas
└── playwright.config.ts                       # Configuración Playwright
```

## 🧪 Tipos de Pruebas

### 1. Pruebas Unitarias

#### Backend (NestJS + Jest)

**Servicios:**
- `AuthService`: Registro, login, validación de usuarios
- `ProductsService`: CRUD de productos, búsqueda, filtrado
- `CategoriesService`: Gestión de categorías

**Guards:**
- `AuthGuard`: Validación de tokens JWT

**Características:**
- Mocking de PrismaService
- Mocking de JwtService
- Cobertura de casos exitosos y de error
- Validación de respuestas y estados

**Ejemplo de ejecución:**
```bash
cd backend
npm run test
npm run test:cov  # Con cobertura
```

#### Frontend (React + Jest + Testing Library)

**Hooks:**
- `useProducts`: Gestión de productos, filtrado, búsqueda
- `useCategories`: Gestión de categorías

**Contextos:**
- `AuthContext`: Autenticación, login, logout, registro

**Componentes:**
- `SearchBar`: Búsqueda en tiempo real, limpieza de input

**Características:**
- Mocking de apiService
- Testing de estados de carga y error
- Testing de interacciones de usuario
- Cobertura de casos edge

**Ejemplo de ejecución:**
```bash
cd frontend
npm run test
npm run test:coverage  # Con cobertura
```

### 2. Pruebas de Integración

#### Backend ↔ Python API

**Endpoints probados:**
- `/ai/health`: Verificación de salud de la API de Python
- `/ai/detect-torso`: Detección de torso en imágenes
- `/ai/virtual-try-on`: Prueba virtual de prendas
- `/ai/analyze-clothing-fit`: Análisis de ajuste de prendas
- `/ai/multiple-angles`: Generación de múltiples ángulos
- `/ai/enhance-image`: Mejora de imágenes

**Características:**
- Testing con datos reales de imagen (base64)
- Manejo de errores de conectividad
- Validación de respuestas de la API de Python
- Testing de autenticación requerida

#### Frontend ↔ Backend

**Flujos probados:**
- Carga de productos desde el backend
- Búsqueda y filtrado de productos
- Navegación a detalles de producto
- Autenticación de usuarios
- Manejo de errores de red

**Características:**
- Testing de componentes completos con datos reales
- Simulación de interacciones de usuario
- Validación de estados de carga y error
- Testing de navegación entre páginas

### 3. Pruebas End-to-End (E2E)

#### Sistema Completo (Playwright)

**Flujos completos:**
- Registro y autenticación de usuarios
- Navegación por el catálogo de productos
- Búsqueda y filtrado de productos
- Visualización de detalles de producto
- Integración con probador virtual
- Panel de administración

**Características:**
- Testing en múltiples navegadores (Chrome, Firefox, Safari)
- Testing en diferentes dispositivos (Desktop, Mobile)
- Testing de rendimiento y tiempos de carga
- Manejo de errores de red y timeouts
- Limpieza automática de datos de prueba

## 🚀 Ejecución de Pruebas

### Script Principal

El proyecto incluye un script `run-tests.sh` que automatiza la ejecución de todas las pruebas:

```bash
# Ejecutar todas las pruebas
./run-tests.sh

# Solo pruebas unitarias
./run-tests.sh --unit

# Solo pruebas de integración
./run-tests.sh --integration

# Solo pruebas E2E
./run-tests.sh --e2e

# Solo pruebas con cobertura
./run-tests.sh --coverage
```

### Ejecución Manual

#### Backend
```bash
cd backend
npm run test              # Pruebas unitarias
npm run test:watch        # Modo watch
npm run test:cov          # Con cobertura
npm run test:e2e          # Pruebas E2E
```

#### Frontend
```bash
cd frontend
npm run test              # Pruebas unitarias
npm run test:watch        # Modo watch
npm run test:coverage     # Con cobertura
```

#### E2E (Playwright)
```bash
# Instalar Playwright
npm install @playwright/test
npx playwright install

# Ejecutar pruebas E2E
npx playwright test

# Ejecutar en modo UI
npx playwright test --ui

# Ejecutar en modo debug
npx playwright test --debug
```

## 📊 Cobertura de Código

### Backend
- **Objetivo**: >80% cobertura
- **Archivos cubiertos**: Servicios, Guards, Controladores
- **Reporte**: `backend/coverage/lcov-report/index.html`

### Frontend
- **Objetivo**: >80% cobertura
- **Archivos cubiertos**: Hooks, Contextos, Componentes
- **Reporte**: `frontend/coverage/lcov-report/index.html`

## 🔧 Configuración

### Variables de Entorno

```bash
# URLs de los servicios
FRONTEND_URL=http://localhost:5173
BACKEND_URL=http://localhost:3000
PYTHON_API_URL=http://localhost:8000

# Configuración de base de datos para testing
DATABASE_URL=postgresql://user:password@localhost:5432/probador_virtual_test
```

### Configuración de Jest

#### Backend (`backend/package.json`)
```json
{
  "jest": {
    "moduleFileExtensions": ["js", "json", "ts"],
    "rootDir": "src",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "collectCoverageFrom": ["**/*.(t|j)s"],
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
```

#### Frontend (`frontend/jest.config.js`)
```javascript
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/src/setupTests.ts'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  collectCoverageFrom: [
    'src/**/*.(ts|tsx)',
    '!src/**/*.d.ts',
    '!src/main.tsx',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
};
```

### Configuración de Playwright

```typescript
// playwright.config.ts
export default defineConfig({
  testDir: './test/e2e',
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/results.xml' }],
  ],
  use: {
    baseURL: process.env.FRONTEND_URL || 'http://localhost:5173',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } },
    { name: 'Mobile Safari', use: { ...devices['iPhone 12'] } },
  ],
  webServer: [
    {
      command: 'cd frontend && npm run dev',
      url: 'http://localhost:5173',
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'cd backend && npm run start:dev',
      url: 'http://localhost:3000',
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'cd python && python run_api.py',
      url: 'http://localhost:8000',
      reuseExistingServer: !process.env.CI,
    },
  ],
});
```

## 📈 Métricas y Reportes

### Reportes Generados

1. **Jest (Unitarias)**
   - HTML: `coverage/lcov-report/index.html`
   - LCOV: `coverage/lcov.info`
   - Texto: Consola

2. **Playwright (E2E)**
   - HTML: `test-results/index.html`
   - JSON: `test-results/results.json`
   - JUnit: `test-results/results.xml`
   - Videos: `test-results/`
   - Screenshots: `test-results/`

### Métricas Objetivo

- **Cobertura de código**: >80%
- **Tiempo de ejecución unitarias**: <30 segundos
- **Tiempo de ejecución E2E**: <5 minutos
- **Tasa de éxito**: >95%

## 🐛 Debugging

### Pruebas Unitarias
```bash
# Debug con Node.js
cd backend
npm run test:debug

# Debug con Jest
cd frontend
npm run test -- --verbose --no-cache
```

### Pruebas E2E
```bash
# Debug con Playwright
npx playwright test --debug

# Ejecutar una prueba específica
npx playwright test full-system.e2e.spec.ts --grep "should complete user registration"

# Ver reporte HTML
npx playwright show-report
```

## 🔄 CI/CD Integration

### GitHub Actions (Ejemplo)

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm install
      - run: ./run-tests.sh --coverage
      - uses: codecov/codecov-action@v3
        with:
          files: ./backend/coverage/lcov.info,./frontend/coverage/lcov.info
```

## 📝 Mejores Prácticas

### Escribir Pruebas

1. **Naming**: Usar nombres descriptivos que expliquen qué se está probando
2. **Arrange-Act-Assert**: Estructura clara de las pruebas
3. **Mocking**: Mockear dependencias externas
4. **Edge Cases**: Probar casos límite y errores
5. **Cleanup**: Limpiar datos de prueba después de cada test

### Mantenimiento

1. **Actualizar mocks** cuando cambien las APIs
2. **Revisar cobertura** regularmente
3. **Refactorizar pruebas** cuando el código cambie
4. **Documentar casos complejos** con comentarios

## 🚨 Troubleshooting

### Problemas Comunes

1. **Tests fallan por timeouts**
   - Aumentar timeout en configuración
   - Verificar que los servicios estén corriendo

2. **Mocks no funcionan**
   - Verificar que los mocks estén antes de los imports
   - Limpiar mocks entre tests

3. **E2E tests fallan**
   - Verificar que todos los servicios estén corriendo
   - Revisar logs de Playwright para más detalles

4. **Cobertura baja**
   - Identificar archivos no cubiertos
   - Agregar tests para casos faltantes

## 📚 Recursos Adicionales

- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [Playwright Documentation](https://playwright.dev/docs/intro)
- [NestJS Testing](https://docs.nestjs.com/fundamentals/testing)

---

**Última actualización**: Octubre 2025  
**Versión**: 1.0.0  
**Mantenido por**: Equipo de Desarrollo StyleAI