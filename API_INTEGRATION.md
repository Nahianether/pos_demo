# POS System API Integration Guide

This POS system now supports both **Local Mode** (using Hive database) and **API Mode** (connecting to your Rust backend).

## Quick Start

### 1. Start Your Backend

Make sure your Rust backend is running:

```bash
cd your-backend-directory
cargo run --release
```

The backend should be running at `http://localhost:3000`

### 2. Configure API in POS App

1. Open the POS app
2. Click the **Settings** icon (gear icon in top right)
3. Find the **API Configuration** section
4. Toggle **"Use API Mode"** to ON
5. Set the API Base URL:
   - **For desktop/local**: `http://localhost:3000/api`
   - **For Android Emulator**: `http://10.0.2.2:3000/api`
   - **For physical device**: `http://YOUR_COMPUTER_IP:3000/api`
6. Click **Update**
7. Check the connection status indicator

### 3. Restart the App

After switching modes, restart the app for changes to take effect.

## Features

### What Works in API Mode

✅ **Products**
- Load all products from backend
- Search products
- Filter by category
- QR code scanning (uses product ID from backend)

✅ **Categories**
- Load categories and subcategories
- Navigate category hierarchy
- Filter products by category

✅ **Cart**
- Add items to cart (creates cart on backend)
- Update quantities
- Remove items
- Clear cart

✅ **Checkout**
- Complete sales
- Apply VAT and discounts
- Multiple payment methods (Cash, Card, Digital Wallet)
- Print receipts
- Generate PDF receipts

✅ **Connection Status**
- Real-time connection checking
- Visual indicators for API status

### API vs Local Mode Comparison

| Feature | Local Mode (Hive) | API Mode (Backend) |
|---------|------------------|-------------------|
| Data Storage | Device only | Centralized backend |
| Multi-device | ❌ No | ✅ Yes |
| Real inventory | ❌ No | ✅ Yes |
| Sales tracking | Local only | Centralized |
| Offline support | ✅ Yes | ❌ No (requires connection) |
| Setup | None | Backend required |

## API Endpoints Used

The POS app communicates with these backend endpoints:

- `GET /api/products` - Load all products
- `GET /api/categories` - Load categories
- `POST /api/carts` - Create new cart
- `GET /api/carts/:id` - Get cart with items
- `POST /api/carts/:id/items` - Add item to cart
- `PUT /api/carts/:id/items/:item_id` - Update quantity
- `DELETE /api/carts/:id/items/:item_id` - Remove item
- `POST /api/sales` - Complete checkout

## Troubleshooting

### Connection Issues

**Problem**: "API Disconnected" message in settings

**Solutions**:
1. Check if backend is running: `curl http://localhost:3000/api/products`
2. Verify the URL is correct (no trailing slash after `/api`)
3. For physical devices, ensure both device and computer are on same network
4. Check firewall settings aren't blocking the connection

### Android Emulator Connection

**Problem**: Can't connect from Android emulator

**Solution**: Use `http://10.0.2.2:3000/api` instead of `localhost`

### Physical Device Connection

**Problem**: Can't connect from physical device

**Solutions**:
1. Find your computer's IP address:
   - Mac: `System Preferences > Network`
   - Windows: `ipconfig` in command prompt
   - Linux: `ip addr show`
2. Use `http://YOUR_IP:3000/api` (e.g., `http://192.168.1.100:3000/api`)
3. Make sure your backend is listening on `0.0.0.0`, not just `127.0.0.1`

### Empty Products List

**Problem**: API connects but no products shown

**Solutions**:
1. Check backend has sample data: `curl http://localhost:3000/api/products`
2. Verify backend ran migrations and seeded data
3. Check backend console for errors

## Development Tips

### Switching Between Modes

You can easily switch between Local and API mode for testing:

1. **Local Mode** (Default)
   - No setup required
   - Instant startup
   - Good for UI/UX development
   - Sample data included

2. **API Mode**
   - Requires backend running
   - Real-time data sync
   - Good for integration testing
   - Use actual backend data

### Testing Workflow

1. Develop UI features in **Local Mode**
2. Test backend integration in **API Mode**
3. Use Settings screen to quickly toggle between modes

### Adding Custom API URL

In the Settings screen, you can add custom URLs for different environments:

- **Development**: `http://localhost:3000/api`
- **Staging**: `http://staging.yourserver.com/api`
- **Production**: `https://api.yourserver.com/api`

## Code Structure

### Key Files

- **`lib/services/api_service.dart`** - All API calls
- **`lib/models/api_models.dart`** - API request/response models
- **`lib/providers/api_pos_provider.dart`** - State management for API mode
- **`lib/providers/pos_riverpod_provider.dart`** - State management for local mode
- **`lib/screens/settings_screen.dart`** - API configuration UI

### How It Works

1. **API Service Layer** (`api_service.dart`)
   - Makes HTTP requests to backend
   - Handles response parsing
   - Manages errors

2. **Provider Layer** (`api_pos_provider.dart`)
   - Manages app state
   - Converts API models to app models
   - Handles loading/error states

3. **UI Layer** (screens/widgets)
   - Same UI for both modes
   - Automatically adapts to data source
   - Shows loading states

## Future Enhancements

Planned features for API mode:

- 🔄 Automatic reconnection on network restore
- 💾 Offline mode with sync when online
- 📊 Sales analytics from backend
- 👥 Multi-user support
- 🔒 Authentication/authorization
- 📱 Push notifications for low stock
- 🎯 Customer management
- 📈 Real-time inventory updates

## Support

For issues or questions:
- Check backend logs for API errors
- Verify network connectivity
- Ensure backend is running with latest code
- Check API documentation in backend repository

## Example: Complete Flow

### Checkout Process in API Mode

```
1. User adds products → POST /api/carts (create cart)
                      → POST /api/carts/:id/items (add items)

2. User adjusts quantities → PUT /api/carts/:id/items/:item_id

3. User clicks checkout → POST /api/sales (complete sale)
                        → Backend deducts inventory
                        → Returns receipt data

4. App prints receipt → Uses data from sale response
                      → Cart cleared on backend
```

## Performance Notes

- API calls are cached where appropriate
- Images loaded asynchronously
- Connection status checked periodically
- Optimistic UI updates for better UX

---

**Note**: Always keep your backend running when using API mode. The app will show connection errors if the backend is unavailable.
