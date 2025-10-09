# Modern POS System - Flutter

A professional Point of Sale (POS) system built with Flutter, featuring Riverpod state management, Hive database for local caching, and a modern UI design.

## Features

### 🎨 Modern UI Design
- Clean, professional interface with smooth animations
- Hover effects and responsive design
- Card-based layout with gradients and shadows
- Image loading with caching support

### 🔄 State Management - Riverpod
- **Riverpod 2.x** for robust and scalable state management
- Reactive data flow with automatic UI updates
- Efficient state caching and optimization

### 💾 Local Database - Hive
- **Hive** for fast, lightweight local storage
- Persistent cart data across app restarts
- Efficient product and category caching
- Type-safe data models with generated adapters

### 🗂️ Multi-Layer Category System
- **3-level deep category hierarchy** (e.g., Food → Burgers → Premium Items)
- Visual breadcrumb navigation
- Easy category navigation with back buttons
- Dynamic subcategory detection

### 🛒 Shopping Cart
- Real-time cart updates stored in Hive
- Quantity adjustment with +/- buttons
- Item removal functionality
- Persistent cart across app sessions
- Running total calculation

### 🔄 Pull-to-Refresh
- Pull-to-refresh on main screen to fetch latest products
- Manual refresh button in top bar
- Visual loading indicator
- Success notification after refresh

### 💳 Checkout System
- Multiple payment methods (Cash, Card, Digital)
- Customer name field (optional)
- Discount support
- Order summary with totals
- Success confirmation dialog

### 🔍 Search Functionality
- Real-time product search
- Clear search button
- Search results displayed in grid
- Fast search through cached products

### 🖼️ Product Images
- Network images with caching (using `cached_network_image`)
- Placeholder during loading
- Graceful error handling
- High-quality product photos from Unsplash

### 📊 Realistic Sample Data
- **43 products** across 15 categories
- 3 main categories:
  - **Food**: Burgers, Pizza, Asian Cuisine, Desserts
  - **Beverages**: Coffee, Tea, Smoothies, Soft Drinks
  - **Groceries**: Dairy, Bakery, Fresh Produce, Snacks
- Real product images
- Realistic pricing and descriptions

## Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Hive Adapters
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
flutter run
```

## How to Use

### Navigation
1. **Browse Categories**: Start at home, click on main categories
2. **Navigate Subcategories**: Click through subcategories
3. **Go Back**: Use the back button in breadcrumb
4. **Reset to Home**: Click the "Home" button

### Shopping
1. **Add to Cart**: Click on any product card
2. **Adjust Quantity**: Use +/- buttons in cart panel
3. **Remove Items**: Click the trash icon
4. **Clear Cart**: Click "Clear" button

### Search
1. Type product name in search bar
2. Results appear instantly
3. Click "X" to clear search

### Refresh Data
1. **Pull-to-refresh**: Pull down on the product grid
2. **Manual refresh**: Click the refresh icon in top bar

### Checkout
1. Click "Checkout" button
2. Enter customer name (optional)
3. Select payment method
4. Add discount if applicable
5. Click "Complete Order"

## Dependencies

### Core
- `flutter_riverpod: ^2.4.9` - State management
- `hive: ^2.2.3` - NoSQL database
- `hive_flutter: ^1.1.0` - Flutter integration

### Utilities
- `intl: ^0.19.0` - Formatting
- `uuid: ^4.2.1` - ID generation
- `cached_network_image: ^3.3.0` - Image caching

### Dev Dependencies
- `hive_generator: ^2.0.1` - Code generation
- `build_runner: ^2.4.7` - Build system

## License

MIT License - Free to use for learning or commercial purposes.
