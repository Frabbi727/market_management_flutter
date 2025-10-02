# App Constants Documentation

This directory contains all the design system constants for the application. Use these constants consistently throughout the app for a cohesive design.

## 📁 Files Overview

### 1. `app_colors.dart`
Centralized color palette for the entire application.

**Usage:**
```dart
import 'package:market_management_flutter/core/constants/app_colors.dart';

Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textWhite),
  ),
)
```

**Categories:**
- **Primary Colors**: `primary`, `primaryLight`, `primaryDark`, `secondary`, `accent`
- **Background**: `background`, `surface`, `surfaceDark`
- **KPI Colors**: `electricity`, `amount`, `acCost`, `serviceCost`, `invoice`, `status`
- **Text Colors**: `textPrimary`, `textSecondary`, `textHint`, `textWhite`
- **Semantic**: `success`, `warning`, `error`, `info`
- **Others**: `border`, `divider`, `shadow`

---

### 2. `app_sizes.dart`
Spacing, sizing, and dimension constants.

**Usage:**
```dart
import 'package:market_management_flutter/core/constants/app_sizes.dart';

Padding(
  padding: EdgeInsets.all(AppSizes.padding),
  child: Container(
    height: AppSizes.buttonHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppSizes.radius),
    ),
  ),
)
```

**Categories:**
- **Padding/Margin**: `paddingXS` to `paddingXXL` (4px to 32px)
- **Border Radius**: `radiusXS` to `radiusXL` (4px to 20px)
- **Icon Sizes**: `iconXS` to `iconXL` (16px to 48px)
- **Elevation**: `elevationNone` to `elevationXL` (0 to 12)
- **Spacing**: `spaceXS` to `spaceXXL` (4px to 48px)
- **Component Sizes**: Button heights, input heights, app bar, navigation rail
- **Card Sizes**: `cardMinHeight`, `kpiCardHeight`

**Size Scale:**
```
XS  = 4px
SM  = 8px
MD  = 12px
(default) = 16px
LG  = 20px/24px
XL  = 24px/32px
XXL = 32px/48px
```

---

### 3. `app_text_styles.dart`
Typography styles following Material Design 3.

**Usage:**
```dart
import 'package:market_management_flutter/core/constants/app_text_styles.dart';

Text(
  'Welcome',
  style: AppTextStyles.headlineLarge,
)

// With modifications
Text(
  'Error Message',
  style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.error),
)
```

**Style Categories:**

1. **Display Styles** (Largest headers)
   - `displayLarge` (57px)
   - `displayMedium` (45px)
   - `displaySmall` (36px)

2. **Headline Styles**
   - `headlineLarge` (32px, bold)
   - `headlineMedium` (28px, semi-bold)
   - `headlineSmall` (24px, semi-bold)

3. **Title Styles**
   - `titleLarge` (22px)
   - `titleMedium` (16px)
   - `titleSmall` (14px)

4. **Body Styles**
   - `bodyLarge` (16px)
   - `bodyMedium` (14px)
   - `bodySmall` (12px)

5. **Label Styles**
   - `labelLarge` (14px)
   - `labelMedium` (12px)
   - `labelSmall` (11px)

6. **Custom Styles**
   - `kpiValue`, `kpiTitle`, `kpiSubtitle`
   - `buttonText`
   - `inputLabel`, `inputText`, `inputHint`
   - `caption`, `overline`

**Helper Methods:**
```dart
AppTextStyles.withColor(style, color)
AppTextStyles.withWeight(style, weight)
AppTextStyles.withSize(style, size)
```

---

### 4. `app_constants.dart`
Application-wide constants (not design-related).

**Usage:**
```dart
import 'package:market_management_flutter/core/constants/app_constants.dart';

// Date formatting
final formatted = DateFormat(AppConstants.displayDateFormat).format(date);

// Validation
if (password.length < AppConstants.minPasswordLength) {
  // Show error
}

// Error messages
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(AppConstants.errorNetwork)),
);
```

**Categories:**
- **App Info**: `appName`, `appVersion`
- **Animation**: Durations for animations
- **Network**: Timeouts, pagination
- **Formats**: Date, time, currency formats
- **Validation**: Password, username rules
- **Messages**: Error and success messages
- **Regex**: Email, phone, number patterns
- **Limits**: File upload sizes, bulk import limits

---

### 5. `app_theme.dart`
Main theme configuration that uses all other constants.

**Usage:**
```dart
import 'package:market_management_flutter/core/constants/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

**Features:**
- Uses `AppColors` for color scheme
- Uses `AppSizes` for spacing and dimensions
- Uses `AppTextStyles` for typography
- Pre-configured Material 3 theme
- Input decoration theme
- Button themes
- Card themes

---

## 📖 Best Practices

### ✅ DO

```dart
// Use constants
Container(
  padding: EdgeInsets.all(AppSizes.padding),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppSizes.radius),
  ),
  child: Text(
    'Hello',
    style: AppTextStyles.titleMedium,
  ),
)

// Use theme colors for KPI cards
KpiCard(
  color: AppColors.electricity,
  // ...
)
```

### ❌ DON'T

```dart
// Don't use hardcoded values
Container(
  padding: EdgeInsets.all(16), // ❌
  decoration: BoxDecoration(
    color: Color(0xFF1976D2), // ❌
    borderRadius: BorderRadius.circular(12), // ❌
  ),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16), // ❌
  ),
)
```

---

## 🎨 Customization

### Changing Colors

Edit `app_colors.dart`:
```dart
static const Color primary = Color(0xFF1976D2); // Change this
```

### Changing Sizes

Edit `app_sizes.dart`:
```dart
static const double padding = 16.0; // Change this
```

### Changing Typography

Edit `app_text_styles.dart`:
```dart
static const TextStyle titleLarge = TextStyle(
  fontSize: 22, // Change this
  fontWeight: FontWeight.w600,
  color: AppColors.textPrimary,
);
```

---

## 📦 Export/Import Pattern

**Option 1: Import individually**
```dart
import 'package:market_management_flutter/core/constants/app_colors.dart';
import 'package:market_management_flutter/core/constants/app_sizes.dart';
```

**Option 2: Import theme (includes everything)**
```dart
import 'package:market_management_flutter/core/constants/app_theme.dart';
// Now you have access to AppColors, AppSizes, AppTextStyles
```

---

## 🔍 Quick Reference

### Common Paddings
```dart
EdgeInsets.all(AppSizes.paddingSM)    // 8px
EdgeInsets.all(AppSizes.padding)      // 16px  ← Most common
EdgeInsets.all(AppSizes.paddingXL)    // 24px
```

### Common Radius
```dart
BorderRadius.circular(AppSizes.radiusMD)  // 8px  ← Buttons
BorderRadius.circular(AppSizes.radius)     // 12px ← Cards
```

### Common Text Styles
```dart
AppTextStyles.headlineSmall  // Page titles
AppTextStyles.titleMedium    // Section headers
AppTextStyles.bodyMedium     // Regular text
AppTextStyles.labelSmall     // Hints/captions
```

### Common Colors
```dart
AppColors.primary       // Buttons, links
AppColors.textPrimary   // Main text
AppColors.textSecondary // Secondary text
AppColors.background    // Page background
```

---

## 🚀 Migration Guide

If you have existing hardcoded values, replace them:

```dart
// Before
Container(
  padding: EdgeInsets.all(16),
  color: Colors.blue,
  child: Text('Hello', style: TextStyle(fontSize: 14)),
)

// After
Container(
  padding: EdgeInsets.all(AppSizes.padding),
  color: AppColors.primary,
  child: Text('Hello', style: AppTextStyles.bodyMedium),
)
```

---

**Note:** These constants ensure consistency across the app and make it easy to update the design system in one place.