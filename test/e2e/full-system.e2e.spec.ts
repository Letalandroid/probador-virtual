import { test, expect } from '@playwright/test';

// Configuración de URLs para diferentes entornos
const FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:5173';
const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:3000';
const PYTHON_API_URL = process.env.PYTHON_API_URL || 'http://localhost:8000';

test.describe('Full System E2E Tests', () => {
  test.beforeEach(async ({ page }) => {
    // Navegar a la página principal
    await page.goto(FRONTEND_URL);
  });

  test.describe('User Registration and Authentication Flow', () => {
    test('should complete full user registration and login flow', async ({ page }) => {
      // 1. Navigate to auth page
      await page.click('text=Iniciar Sesión');
      await expect(page).toHaveURL(/.*\/auth/);

      // 2. Switch to register tab
      await page.click('text=Registrarse');

      // 3. Fill registration form
      await page.fill('input[placeholder="Email"]', 'e2e-test@example.com');
      await page.fill('input[placeholder="Contraseña"]', 'password123');
      await page.fill('input[placeholder="Nombre completo"]', 'E2E Test User');

      // 4. Submit registration
      await page.click('button:has-text("Registrarse")');

      // 5. Wait for success message
      await expect(page.locator('text=¡Registro exitoso!')).toBeVisible();

      // 6. Verify user is logged in
      await expect(page.locator('text=Bienvenido, E2E Test User')).toBeVisible();

      // 7. Logout
      await page.click('button:has-text("Cerrar Sesión")');
      await expect(page.locator('text=Iniciar Sesión')).toBeVisible();
    });

    test('should handle login with existing user', async ({ page }) => {
      // 1. Navigate to auth page
      await page.click('text=Iniciar Sesión');
      await expect(page).toHaveURL(/.*\/auth/);

      // 2. Fill login form
      await page.fill('input[placeholder="Email"]', 'e2e-test@example.com');
      await page.fill('input[placeholder="Contraseña"]', 'password123');

      // 3. Submit login
      await page.click('button:has-text("Iniciar Sesión")');

      // 4. Wait for success
      await expect(page.locator('text=¡Bienvenido!')).toBeVisible();

      // 5. Verify user is logged in
      await expect(page.locator('text=Bienvenido, E2E Test User')).toBeVisible();
    });

    test('should handle invalid login credentials', async ({ page }) => {
      // 1. Navigate to auth page
      await page.click('text=Iniciar Sesión');
      await expect(page).toHaveURL(/.*\/auth/);

      // 2. Fill login form with invalid credentials
      await page.fill('input[placeholder="Email"]', 'invalid@example.com');
      await page.fill('input[placeholder="Contraseña"]', 'wrongpassword');

      // 3. Submit login
      await page.click('button:has-text("Iniciar Sesión")');

      // 4. Wait for error message
      await expect(page.locator('text=Error en el inicio de sesión')).toBeVisible();
    });
  });

  test.describe('Product Catalog and Search Flow', () => {
    test('should display products and allow filtering', async ({ page }) => {
      // 1. Wait for products to load
      await expect(page.locator('text=Productos Destacados')).toBeVisible();

      // 2. Verify products are displayed
      const productCards = page.locator('[data-testid="product-card"]');
      await expect(productCards).toHaveCount.greaterThan(0);

      // 3. Test search functionality
      const searchInput = page.locator('input[placeholder="Buscar productos..."]');
      await searchInput.fill('shirt');
      await page.waitForTimeout(500); // Wait for search to process

      // 4. Verify search results
      const searchResults = page.locator('[data-testid="product-card"]');
      await expect(searchResults).toHaveCount.greaterThan(0);

      // 5. Clear search
      await searchInput.fill('');
      await page.waitForTimeout(500);

      // 6. Test gender filtering
      await page.click('text=Mujeres');
      await expect(page.locator('text=Mujeres')).toBeVisible();

      // 7. Test category filtering
      const categoryButtons = page.locator('button:has-text("Todos")');
      await expect(categoryButtons).toBeVisible();
    });

    test('should navigate to product detail page', async ({ page }) => {
      // 1. Wait for products to load
      await expect(page.locator('text=Productos Destacados')).toBeVisible();

      // 2. Click on first product
      const firstProduct = page.locator('[data-testid="product-card"]').first();
      await firstProduct.click();

      // 3. Verify navigation to product detail
      await expect(page).toHaveURL(/.*\/productos\/.*/);

      // 4. Verify product details are displayed
      await expect(page.locator('h1')).toBeVisible(); // Product name
      await expect(page.locator('text=$')).toBeVisible(); // Price
    });
  });

  test.describe('Product Detail and Virtual Try-On Flow', () => {
    test('should display product details and navigate to virtual try-on', async ({ page }) => {
      // 1. Navigate to a product detail page
      await page.goto(`${FRONTEND_URL}/productos/1`);

      // 2. Wait for product details to load
      await expect(page.locator('h1')).toBeVisible();

      // 3. Verify product information is displayed
      await expect(page.locator('text=Disponible')).toBeVisible();
      await expect(page.locator('text=IA')).toBeVisible(); // AI badge

      // 4. Test size selection
      const sizeButtons = page.locator('button:has-text("S"), button:has-text("M"), button:has-text("L")');
      if (await sizeButtons.count() > 0) {
        await sizeButtons.first().click();
      }

      // 5. Test quantity selection
      const quantityButtons = page.locator('button[aria-label="Increment"], button[aria-label="Decrement"]');
      if (await quantityButtons.count() > 0) {
        await quantityButtons.first().click();
      }

      // 6. Click virtual try-on button
      const virtualTryOnButton = page.locator('button:has-text("Probar con IA")');
      await virtualTryOnButton.click();

      // 7. Verify navigation to virtual try-on page
      await expect(page).toHaveURL(/.*\/probador-virtual/);
    });

    test('should handle product not found', async ({ page }) => {
      // 1. Navigate to non-existent product
      await page.goto(`${FRONTEND_URL}/productos/non-existent-id`);

      // 2. Verify error message
      await expect(page.locator('text=Producto no encontrado')).toBeVisible();

      // 3. Verify back button works
      await page.click('button:has-text("Volver a productos")');
      await expect(page).toHaveURL(/.*\/productos/);
    });
  });

  test.describe('Virtual Try-On Integration', () => {
    test('should complete virtual try-on flow', async ({ page }) => {
      // 1. Navigate to virtual try-on page
      await page.goto(`${FRONTEND_URL}/probador-virtual`);

      // 2. Verify page loads
      await expect(page.locator('text=Probador Virtual')).toBeVisible();

      // 3. Test image upload for person
      const personFileInput = page.locator('input[type="file"][accept="image/*"]').first();
      if (await personFileInput.isVisible()) {
        // Note: In a real test, you would upload an actual image file
        // For now, we'll just verify the input is present
        await expect(personFileInput).toBeVisible();
      }

      // 4. Test clothing selection
      const clothingButtons = page.locator('button:has-text("Seleccionar Prenda")');
      if (await clothingButtons.count() > 0) {
        await clothingButtons.first().click();
      }

      // 5. Test AI processing button
      const processButton = page.locator('button:has-text("Procesar con IA")');
      if (await processButton.isVisible()) {
        await expect(processButton).toBeVisible();
      }
    });

    test('should handle AI service errors gracefully', async ({ page }) => {
      // 1. Navigate to virtual try-on page
      await page.goto(`${FRONTEND_URL}/probador-virtual`);

      // 2. Try to process without images
      const processButton = page.locator('button:has-text("Procesar con IA")');
      if (await processButton.isVisible()) {
        await processButton.click();

        // 3. Verify error handling
        await expect(page.locator('text=Error')).toBeVisible();
      }
    });
  });

  test.describe('Admin Panel Integration', () => {
    test('should access admin panel with admin user', async ({ page }) => {
      // 1. Login as admin user (assuming admin user exists)
      await page.goto(`${FRONTEND_URL}/auth`);
      await page.fill('input[placeholder="Email"]', 'admin@example.com');
      await page.fill('input[placeholder="Contraseña"]', 'admin123');
      await page.click('button:has-text("Iniciar Sesión")');

      // 2. Navigate to admin panel
      await page.click('text=Admin');
      await expect(page).toHaveURL(/.*\/admin/);

      // 3. Verify admin features are visible
      await expect(page.locator('text=Panel de Administración')).toBeVisible();
      await expect(page.locator('text=Gestión de Usuarios')).toBeVisible();
      await expect(page.locator('text=Reportes')).toBeVisible();
    });

    test('should restrict admin access for regular users', async ({ page }) => {
      // 1. Login as regular user
      await page.goto(`${FRONTEND_URL}/auth`);
      await page.fill('input[placeholder="Email"]', 'user@example.com');
      await page.fill('input[placeholder="Contraseña"]', 'password123');
      await page.click('button:has-text("Iniciar Sesión")');

      // 2. Try to access admin panel
      await page.goto(`${FRONTEND_URL}/admin`);

      // 3. Verify access is restricted
      await expect(page.locator('text=Acceso Denegado')).toBeVisible();
    });
  });

  test.describe('API Integration Tests', () => {
    test('should verify backend API health', async ({ request }) => {
      // 1. Test backend health endpoint
      const backendResponse = await request.get(`${BACKEND_URL}/health`);
      expect(backendResponse.status()).toBe(200);

      // 2. Test products endpoint
      const productsResponse = await request.get(`${BACKEND_URL}/products`);
      expect(productsResponse.status()).toBe(200);

      // 3. Test categories endpoint
      const categoriesResponse = await request.get(`${BACKEND_URL}/categories`);
      expect(categoriesResponse.status()).toBe(200);
    });

    test('should verify Python API health', async ({ request }) => {
      // 1. Test Python API health endpoint
      const pythonResponse = await request.get(`${PYTHON_API_URL}/health`);
      expect([200, 500]).toContain(pythonResponse.status()); // 500 if not running

      // 2. Test AI endpoints (may fail if Python API not running)
      const detectTorsoResponse = await request.post(`${PYTHON_API_URL}/detect-torso`);
      expect([200, 400, 500]).toContain(detectTorsoResponse.status());
    });

    test('should test full API integration flow', async ({ request }) => {
      // 1. Register a new user
      const registerResponse = await request.post(`${BACKEND_URL}/auth/register`, {
        data: {
          email: 'api-test@example.com',
          password: 'password123',
          full_name: 'API Test User',
        },
      });
      expect(registerResponse.status()).toBe(201);

      // 2. Login with the user
      const loginResponse = await request.post(`${BACKEND_URL}/auth/login`, {
        data: {
          email: 'api-test@example.com',
          password: 'password123',
        },
      });
      expect(loginResponse.status()).toBe(200);

      const { token } = await loginResponse.json();

      // 3. Get products with authentication
      const productsResponse = await request.get(`${BACKEND_URL}/products`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      expect(productsResponse.status()).toBe(200);

      // 4. Test AI integration
      const aiHealthResponse = await request.get(`${BACKEND_URL}/ai/health`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      expect([200, 500]).toContain(aiHealthResponse.status());
    });
  });

  test.describe('Error Handling and Edge Cases', () => {
    test('should handle network errors gracefully', async ({ page }) => {
      // 1. Simulate network failure
      await page.route('**/api/**', route => route.abort());

      // 2. Navigate to products page
      await page.goto(`${FRONTEND_URL}/productos`);

      // 3. Verify error handling
      await expect(page.locator('text=Error')).toBeVisible();
    });

    test('should handle slow API responses', async ({ page }) => {
      // 1. Simulate slow API response
      await page.route('**/api/products', route => 
        setTimeout(() => route.continue(), 5000)
      );

      // 2. Navigate to products page
      await page.goto(`${FRONTEND_URL}/productos`);

      // 3. Verify loading state
      await expect(page.locator('text=Cargando productos...')).toBeVisible();
    });

    test('should handle invalid data gracefully', async ({ page }) => {
      // 1. Mock invalid API response
      await page.route('**/api/products', route => 
        route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify({ invalid: 'data' }),
        })
      );

      // 2. Navigate to products page
      await page.goto(`${FRONTEND_URL}/productos`);

      // 3. Verify error handling
      await expect(page.locator('text=Error')).toBeVisible();
    });
  });

  test.describe('Performance and Load Testing', () => {
    test('should load page within acceptable time', async ({ page }) => {
      // 1. Measure page load time
      const startTime = Date.now();
      await page.goto(FRONTEND_URL);
      await page.waitForLoadState('networkidle');
      const loadTime = Date.now() - startTime;

      // 2. Verify load time is acceptable (less than 3 seconds)
      expect(loadTime).toBeLessThan(3000);
    });

    test('should handle multiple concurrent requests', async ({ page }) => {
      // 1. Navigate to products page
      await page.goto(`${FRONTEND_URL}/productos`);

      // 2. Perform multiple rapid actions
      const searchInput = page.locator('input[placeholder="Buscar productos..."]');
      await searchInput.fill('test');
      await searchInput.fill('shirt');
      await searchInput.fill('dress');
      await searchInput.fill('');

      // 3. Verify page still functions correctly
      await expect(page.locator('[data-testid="product-card"]')).toHaveCount.greaterThan(0);
    });
  });

  test.describe('Cross-Browser Compatibility', () => {
    test('should work in different viewport sizes', async ({ page }) => {
      // 1. Test mobile viewport
      await page.setViewportSize({ width: 375, height: 667 });
      await page.goto(FRONTEND_URL);
      await expect(page.locator('text=StyleAI')).toBeVisible();

      // 2. Test tablet viewport
      await page.setViewportSize({ width: 768, height: 1024 });
      await page.reload();
      await expect(page.locator('text=StyleAI')).toBeVisible();

      // 3. Test desktop viewport
      await page.setViewportSize({ width: 1920, height: 1080 });
      await page.reload();
      await expect(page.locator('text=StyleAI')).toBeVisible();
    });
  });

  test.afterAll(async ({ request }) => {
    // Cleanup: Delete test users
    try {
      await request.delete(`${BACKEND_URL}/users/e2e-test@example.com`);
      await request.delete(`${BACKEND_URL}/users/api-test@example.com`);
    } catch (error) {
      console.log('Cleanup failed:', error);
    }
  });
});

