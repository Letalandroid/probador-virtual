import { chromium, FullConfig } from '@playwright/test';

async function globalSetup(config: FullConfig) {
  console.log('🚀 Starting global setup...');

  // Check if all services are running
  const services = [
    { name: 'Frontend', url: process.env.FRONTEND_URL || 'http://localhost:5173' },
    { name: 'Backend', url: process.env.BACKEND_URL || 'http://localhost:3000' },
    { name: 'Python API', url: process.env.PYTHON_API_URL || 'http://localhost:8000' },
  ];

  for (const service of services) {
    try {
      const response = await fetch(service.url);
      if (response.ok) {
        console.log(`✅ ${service.name} is running at ${service.url}`);
      } else {
        console.log(`⚠️  ${service.name} responded with status ${response.status}`);
      }
    } catch (error) {
      console.log(`❌ ${service.name} is not accessible at ${service.url}`);
      console.log(`   Error: ${error.message}`);
    }
  }

  // Create test data if needed
  await createTestData();

  console.log('✅ Global setup completed');
}

async function createTestData() {
  console.log('📝 Creating test data...');

  try {
    const backendUrl = process.env.BACKEND_URL || 'http://localhost:3000';

    // Create test categories
    const categories = [
      { name: 'Shirts', description: 'All types of shirts' },
      { name: 'Dresses', description: 'All types of dresses' },
      { name: 'Pants', description: 'All types of pants' },
      { name: 'Jackets', description: 'All types of jackets' },
    ];

    for (const category of categories) {
      try {
        await fetch(`${backendUrl}/categories`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(category),
        });
      } catch (error) {
        // Category might already exist, continue
      }
    }

    // Create test products
    const products = [
      {
        name: 'Test Shirt 1',
        description: 'A comfortable test shirt',
        price: 29.99,
        category_id: '1', // Assuming first category
        brand: 'TestBrand',
        color: 'Blue',
        sizes: ['S', 'M', 'L'],
        images: ['https://via.placeholder.com/300x400/0000FF/FFFFFF?text=Shirt1'],
        stock_quantity: 10,
        is_active: true,
        gender: 'men',
      },
      {
        name: 'Test Dress 1',
        description: 'An elegant test dress',
        price: 59.99,
        category_id: '2', // Assuming second category
        brand: 'TestBrand',
        color: 'Red',
        sizes: ['XS', 'S', 'M', 'L'],
        images: ['https://via.placeholder.com/300x400/FF0000/FFFFFF?text=Dress1'],
        stock_quantity: 5,
        is_active: true,
        gender: 'women',
      },
    ];

    for (const product of products) {
      try {
        await fetch(`${backendUrl}/products`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(product),
        });
      } catch (error) {
        // Product might already exist, continue
      }
    }

    console.log('✅ Test data created successfully');
  } catch (error) {
    console.log('⚠️  Could not create test data:', error.message);
  }
}

export default globalSetup;
