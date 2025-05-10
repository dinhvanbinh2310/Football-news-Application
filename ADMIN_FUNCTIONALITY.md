# Admin Panel Functionality

## How to Access the Admin Panel

1. Log in with the demo admin credentials:
   - Email: `admin@example.com`
   - Password: `admin123`

2. After logging in, you'll see an admin icon (shield icon) in the top navigation bar.

3. Click the admin icon to access the admin panel.

## Admin Panel Features

### User Management
- View all users
- Edit user information
- Delete users
- Change user roles (assign or revoke admin privileges)

### Product Management
- Create new products
- View and edit existing products
- Delete products
- Filter products by category

### Order Management (Coming Soon)
- View all orders
- Process and confirm orders

## Development Notes

The admin functionality is currently in demo mode and uses local data. In production, this would connect to a backend API.

To toggle between demo mode and real API mode, change the `useDemoMode` flag in the `ApiService` class:

```dart
// In lib/services/auth_service.dart
static bool useDemoMode = false; // Set to false to use real API
``` 