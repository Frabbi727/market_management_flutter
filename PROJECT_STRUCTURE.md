# Market Management Flutter App

## Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── constants/
│   │   ├── api_constants.dart    # API endpoints
│   │   └── app_routes.dart       # App routes
│   ├── network/
│   │   ├── dio_client.dart       # Dio HTTP client
│   │   └── api_result.dart       # API response wrapper
│   └── utils/                    # Utility functions
│
├── shared/                        # Shared widgets and models
│   ├── widgets/
│   │   ├── main_layout.dart      # Main app layout with navigation
│   │   ├── app_navigation_rail.dart  # Left navigation bar
│   │   ├── kpi_card.dart         # KPI display card
│   │   └── period_picker.dart    # Month/year picker
│   └── models/                   # Shared data models
│
├── features/                      # Feature modules
│   ├── dashboard/
│   │   ├── ui/
│   │   │   └── dashboard_screen.dart
│   │   ├── logic/
│   │   │   └── dashboard_providers.dart  # Riverpod providers
│   │   └── models/
│   │       ├── dashboard_summary.dart
│   │       └── dashboard_service.dart
│   │
│   ├── shops/
│   │   ├── ui/
│   │   ├── logic/
│   │   └── models/
│   │
│   ├── meters/
│   │   ├── ui/
│   │   ├── logic/
│   │   └── models/
│   │
│   ├── tariffs/
│   │   ├── ui/
│   │   ├── logic/
│   │   └── models/
│   │
│   ├── monthly_inputs/
│   │   ├── ui/
│   │   ├── logic/
│   │   └── models/
│   │
│   ├── billing/
│   │   ├── ui/
│   │   ├── logic/
│   │   └── models/
│   │
│   ├── invoices/
│   │   ├── ui/
│   │   ├── logic/
│   │   └── models/
│   │
│   └── reports/
│       ├── ui/
│       ├── logic/
│       └── models/
│
└── main.dart                     # App entry point
```

## Architecture

### Clean Architecture Principles

1. **UI Layer** (`ui/`): Flutter widgets and screens
2. **Logic Layer** (`logic/`): Riverpod providers, state management, business logic
3. **Model Layer** (`models/`): Data models and API services

### State Management

- **Riverpod**: Used for state management
- **Providers**: Located in `logic/` folders
- **Code Generation**: Used for Riverpod and JSON serialization

### Networking

- **Dio**: HTTP client for API calls
- **Interceptors**: Logging and authentication
- **ApiResult**: Sealed class for handling API responses

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Update API URL in `lib/core/constants/api_constants.dart`

4. Run the app:
```bash
flutter run -d chrome  # For web
flutter run            # For mobile
```

## Features

### Implemented
- ✅ Navigation bar (left rail)
- ✅ Dashboard with KPI cards
- ✅ Period picker
- ✅ Riverpod state management
- ✅ Dio network client
- ✅ Clean architecture structure

### Pending
- ⏳ Shops management
- ⏳ Meters & Readings
- ⏳ Tariffs
- ⏳ Monthly Inputs
- ⏳ Billing (Compute)
- ⏳ Invoices
- ⏳ Reports

## Code Generation

When you add new models with `@JsonSerializable()` or new Riverpod providers with `@riverpod`, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## API Integration

Update the `baseUrl` in `lib/core/constants/api_constants.dart` to point to your backend API.

### Expected API Endpoints

- `GET /reports/summary?period=YYYY-MM` - Dashboard summary
- `GET /invoices?period=YYYY-MM` - Invoices list
- `GET/POST/PUT/DELETE /shops` - Shops CRUD
- `GET/POST/PUT/DELETE /meters` - Meters CRUD
- `GET /readings?period=YYYY-MM` - Readings list
- `POST /readings` - Add reading
- `GET /tariffs?utility=ELECTRIC` - Tariffs list
- `POST /tariffs` - Add tariff

## Development Guidelines

1. **Keep separation of concerns**: UI, Logic, Models in separate folders
2. **Use Riverpod providers**: For state management and dependency injection
3. **JSON Serialization**: Use `json_serializable` for model serialization
4. **Error Handling**: Use `ApiResult` sealed class for API responses
5. **Code Generation**: Run build_runner after model changes