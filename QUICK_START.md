# Quick Start Guide

## ✅ Setup Complete

Your Market Management Flutter app is ready with:

1. **Clean Architecture** - Separated UI, Logic, and Models
2. **Riverpod State Management** - Type-safe state management
3. **Dio HTTP Client** - Network layer with interceptors
4. **Navigation** - Left navigation rail with 8 screens
5. **Dashboard** - Fully functional with KPI cards and period picker

## 🚀 Run the App

### For Web
```bash
flutter run -d chrome
```

### For Android/iOS
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── core/                    # Core infrastructure
│   ├── constants/          # API URLs, routes
│   └── network/            # Dio client, API result wrapper
│
├── shared/                  # Reusable widgets
│   └── widgets/            # KPI cards, period picker, navigation
│
├── features/               # Feature modules
│   ├── dashboard/         # ✅ Fully implemented
│   │   ├── ui/           # Dashboard screen
│   │   ├── logic/        # Riverpod providers
│   │   └── models/       # Data models & API service
│   │
│   ├── shops/            # ⏳ Placeholder
│   ├── meters/           # ⏳ Placeholder
│   ├── tariffs/          # ⏳ Placeholder
│   ├── monthly_inputs/   # ⏳ Placeholder
│   ├── billing/          # ⏳ Placeholder
│   ├── invoices/         # ⏳ Placeholder
│   └── reports/          # ⏳ Placeholder
│
└── main.dart              # App entry point
```

## 🔧 Configuration

### 1. Update API URL

Edit `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'http://YOUR_API_URL/api';
  // ...
}
```

### 2. API Endpoints

The app expects these endpoints:

- `GET /reports/summary?period=YYYY-MM` - Dashboard KPIs
- `GET /invoices?period=YYYY-MM` - Invoice list
- `GET/POST/PUT/DELETE /shops` - Shops CRUD
- `GET/POST/PUT/DELETE /meters` - Meters CRUD
- `GET /readings?period=YYYY-MM` - Meter readings
- `POST /readings` - Add reading
- `GET /tariffs?utility=ELECTRIC` - Tariff list
- `POST /tariffs` - Add tariff

### 3. Expected Dashboard API Response

```json
{
  "total_electricity_units": 12500.50,
  "total_electricity_amount": 125000.00,
  "total_ac_cost": 15000.00,
  "total_service_cost": 8000.00,
  "total_invoices_amount": 148000.00,
  "paid_invoices_count": 25,
  "unpaid_invoices_count": 5
}
```

## 📝 Development Workflow

### Adding New Features

For each feature (shops, meters, etc.), follow this pattern:

1. **Models** (`models/` folder)
```dart
import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop {
  final int id;
  final String code;
  final String name;
  // ... other fields

  Shop({required this.id, required this.code, required this.name});

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}
```

2. **Service** (`models/` folder)
```dart
class ShopService {
  final DioClient _dioClient;

  ShopService(this._dioClient);

  Future<List<Shop>> getShops() async {
    final response = await _dioClient.get('/shops');
    return (response.data as List)
        .map((json) => Shop.fromJson(json))
        .toList();
  }
}

final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(ref.watch(dioClientProvider));
});
```

3. **Logic/Providers** (`logic/` folder)
```dart
final shopsProvider = FutureProvider.autoDispose<List<Shop>>((ref) async {
  final service = ref.watch(shopServiceProvider);
  return await service.getShops();
});
```

4. **UI** (`ui/` folder)
```dart
class ShopsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopsAsync = ref.watch(shopsProvider);

    return shopsAsync.when(
      data: (shops) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => ErrorWidget(err),
    );
  }
}
```

5. **Run Code Generation**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎯 Next Steps

1. **Shops Screen**: Implement CRUD operations for shops
2. **Meters Screen**: Add meters table and readings tab
3. **Tariffs Screen**: Manage electricity tariffs
4. **Monthly Inputs**: AC and service cost inputs
5. **Billing**: Compute billing logic
6. **Invoices**: Generate and manage invoices
7. **Reports**: Various reports and analytics

## 📚 Key Files to Know

- `lib/main.dart` - App entry and navigation setup
- `lib/core/network/dio_client.dart` - HTTP client configuration
- `lib/shared/widgets/main_layout.dart` - Main app layout
- `lib/features/dashboard/` - Full dashboard implementation (use as reference)

## 🛠️ Useful Commands

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs

# Run on Chrome
flutter run -d chrome

# Build for web
flutter build web

# Clean build
flutter clean && flutter pub get
```

## 💡 Tips

1. **State Management**: Use Riverpod providers in `logic/` folders
2. **Separation**: Keep UI, Logic, and Models separate
3. **Code Generation**: Run build_runner after adding/modifying models
4. **Error Handling**: Use `AsyncValue.when()` for loading/error states
5. **Navigation**: Update `lib/main.dart` when adding new screens

## 🐛 Troubleshooting

### Build runner errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Import errors
Make sure all imports use relative paths within features and absolute paths from lib/

### API errors
Check the Dio interceptor logs in the console for request/response details

---

**Ready to go!** Start by implementing the Shops screen following the dashboard pattern. 🚀