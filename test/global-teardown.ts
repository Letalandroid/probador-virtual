import { FullConfig } from '@playwright/test';

async function globalTeardown(config: FullConfig) {
  console.log('🧹 Starting global teardown...');

  try {
    const backendUrl = process.env.BACKEND_URL || 'http://localhost:3000';

    // Clean up test users
    const testEmails = [
      'e2e-test@example.com',
      'api-test@example.com',
      'test@example.com',
    ];

    for (const email of testEmails) {
      try {
        // First, try to get the user ID
        const userResponse = await fetch(`${backendUrl}/users?email=${email}`);
        if (userResponse.ok) {
          const users = await userResponse.json();
          if (users.length > 0) {
            const userId = users[0].id;
            
            // Delete the user
            await fetch(`${backendUrl}/users/${userId}`, {
              method: 'DELETE',
            });
            console.log(`✅ Cleaned up user: ${email}`);
          }
        }
      } catch (error) {
        console.log(`⚠️  Could not clean up user ${email}:`, error.message);
      }
    }

    // Clean up test products
    try {
      const productsResponse = await fetch(`${backendUrl}/products`);
      if (productsResponse.ok) {
        const products = await productsResponse.json();
        const testProducts = products.filter((product: any) => 
          product.name.includes('Test') || product.brand === 'TestBrand'
        );

        for (const product of testProducts) {
          try {
            await fetch(`${backendUrl}/products/${product.id}`, {
              method: 'DELETE',
            });
            console.log(`✅ Cleaned up product: ${product.name}`);
          } catch (error) {
            console.log(`⚠️  Could not clean up product ${product.name}:`, error.message);
          }
        }
      }
    } catch (error) {
      console.log('⚠️  Could not clean up test products:', error.message);
    }

    // Clean up test categories
    try {
      const categoriesResponse = await fetch(`${backendUrl}/categories`);
      if (categoriesResponse.ok) {
        const categories = await categoriesResponse.json();
        const testCategories = categories.filter((category: any) => 
          ['Shirts', 'Dresses', 'Pants', 'Jackets'].includes(category.name)
        );

        for (const category of testCategories) {
          try {
            await fetch(`${backendUrl}/categories/${category.id}`, {
              method: 'DELETE',
            });
            console.log(`✅ Cleaned up category: ${category.name}`);
          } catch (error) {
            console.log(`⚠️  Could not clean up category ${category.name}:`, error.message);
          }
        }
      }
    } catch (error) {
      console.log('⚠️  Could not clean up test categories:', error.message);
    }

    console.log('✅ Global teardown completed');
  } catch (error) {
    console.log('❌ Global teardown failed:', error.message);
  }
}

export default globalTeardown;
