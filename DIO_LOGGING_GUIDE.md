# Dio Interceptor Logging Guide

## ✅ What Was Added

I've added a comprehensive Dio interceptor to `lib/core/network/dio_client.dart` that logs:

- ✅ **Request Details**: Method, URL, Headers, Query Parameters, Body
- ✅ **Response Details**: Status Code, Headers, Response Data
- ✅ **Error Details**: Error Type, Message, Status Code

## 📊 Sample Console Output

### Successful Request

When you call the Shops API, you'll see:

```
╔═══════════════════════════════════════════════════════════════
║ 🚀 REQUEST
╠═══════════════════════════════════════════════════════════════
║ Method: GET
║ URL: http://localhost:8080/api/v1/shops
║ Base URL: http://localhost:8080/api/v1
║ Path: /shops
║ Headers:
║   Content-Type: application/json
║   Accept: application/json
╚═══════════════════════════════════════════════════════════════

╔═══════════════════════════════════════════════════════════════
║ ✅ RESPONSE
╠═══════════════════════════════════════════════════════════════
║ URL: http://localhost:8080/api/v1/shops
║ Status Code: 200
║ Status Message: OK
║ Response Headers:
║   content-type: application/json
║   content-length: 1234
║ Response Data:
║   [List with 50 items]
║   First item: {id: 1, shopName: Shop A, code: S001, ...}
╚═══════════════════════════════════════════════════════════════
```

### POST Request with Body

```
╔═══════════════════════════════════════════════════════════════
║ 🚀 REQUEST
╠═══════════════════════════════════════════════════════════════
║ Method: POST
║ URL: http://localhost:8080/api/v1/shops
║ Base URL: http://localhost:8080/api/v1
║ Path: /shops
║ Headers:
║   Content-Type: application/json
║   Accept: application/json
║ Request Body:
║   {shopName: New Shop, code: S099, market: Market A, ...}
╚═══════════════════════════════════════════════════════════════

╔═══════════════════════════════════════════════════════════════
║ ✅ RESPONSE
╠═══════════════════════════════════════════════════════════════
║ URL: http://localhost:8080/api/v1/shops
║ Status Code: 201
║ Status Message: Created
║ Response Headers:
║   content-type: application/json
║ Response Data:
║   {id: 51, shopName: New Shop, code: S099, ...}
╚═══════════════════════════════════════════════════════════════
```

### Request with Query Parameters

```
╔═══════════════════════════════════════════════════════════════
║ 🚀 REQUEST
╠═══════════════════════════════════════════════════════════════
║ Method: GET
║ URL: http://localhost:8080/api/v1/reports/summary?period=2025-01
║ Base URL: http://localhost:8080/api/v1
║ Path: /reports/summary
║ Query Parameters: {period: 2025-01}
║ Headers:
║   Content-Type: application/json
║   Accept: application/json
╚═══════════════════════════════════════════════════════════════
```

### Error Response

```
╔═══════════════════════════════════════════════════════════════
║ ❌ ERROR
╠═══════════════════════════════════════════════════════════════
║ URL: http://localhost:8080/api/v1/shops/999
║ Method: GET
║ Error Type: DioExceptionType.badResponse
║ Error Message: Http status error [404]
║ Status Code: 404
║ Status Message: Not Found
║ Response Data: {error: Shop not found}
╚═══════════════════════════════════════════════════════════════
```

### Network Error (API not running)

```
╔═══════════════════════════════════════════════════════════════
║ ❌ ERROR
╠═══════════════════════════════════════════════════════════════
║ URL: http://localhost:8080/api/v1/shops
║ Method: GET
║ Error Type: DioExceptionType.connectionError
║ Error Message: Connection refused
╚═══════════════════════════════════════════════════════════════
```

## 🎯 Features

### 1. **Visual Formatting**
- Box-drawing characters for clear separation
- Emoji indicators (🚀 REQUEST, ✅ RESPONSE, ❌ ERROR)
- Easy to scan in console

### 2. **Smart Response Data Logging**
- For **Lists**: Shows count and first item preview
- For **Maps**: Shows full object (can be large)
- Prevents console overload with huge arrays

### 3. **Dual Logging**
- **Console logs** (`print`): Easy to see immediately
- **Developer logs** (`developer.log`): Viewable in Flutter DevTools

### 4. **Complete Information**
Every request shows:
- HTTP Method (GET, POST, PUT, DELETE, PATCH)
- Full URL with base URL
- Path
- Query parameters (if any)
- All headers
- Request body (if any)
- Status code
- Response headers
- Response data

## 🔍 Viewing Logs

### In VS Code / IDE
Logs appear in the **Debug Console** when running the app.

### In Terminal
```bash
flutter run -d chrome
# Logs appear in the terminal output
```

### In Flutter DevTools
1. Open Flutter DevTools
2. Go to **Logging** tab
3. Filter by name: `DioClient` or `DashboardService`

## 📝 Current API Logs

When you load the dashboard, you'll see logs for:

1. **Shops API Call**
   ```
   DashboardService: 📡 Fetching shops from: http://localhost:8080/api/v1/shops
   DioClient: REQUEST: GET http://localhost:8080/api/v1/shops
   DioClient: RESPONSE: 200 - GET http://localhost:8080/api/v1/shops
   DashboardService: 🏪 Successfully fetched X shops
   🏪 Total Shops: X
   ```

## ⚙️ Customization

### Disable Logging in Production

To disable logs in production, you can modify the interceptor:

```dart
import 'package:flutter/foundation.dart';

DioClient() : _dio = Dio(...) {
  if (kDebugMode) {
    // Only add logging in debug mode
    _dio.interceptors.add(...);
  }
}
```

### Change Log Detail Level

Modify the interceptor in `dio_client.dart`:

```dart
// Minimal logging (only URL and status)
print('${options.method} ${uri}');

// Or detailed logging (current implementation)
// Shows everything
```

## 🎨 Color Output (Optional)

For colored console output, you can use ANSI color codes:

```dart
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String blue = '\x1B[34m';
const String reset = '\x1B[0m';

print('${green}✅ RESPONSE${reset}');
print('${red}❌ ERROR${reset}');
```

## 📱 Mobile Development

When testing on mobile devices, view logs in:
- **Android**: Android Studio Logcat
- **iOS**: Xcode Console
- **Both**: Flutter DevTools

---

**Note**: The `print` statements are intentional for development and should be wrapped in `kDebugMode` checks for production builds.