# Design System Constants - Quick Guide

## 📦 New Files Created

```
lib/core/constants/
├── app_colors.dart          # Color palette
├── app_sizes.dart           # Spacing, padding, margins, sizes
├── app_text_styles.dart     # Typography styles
├── app_constants.dart       # App-wide constants
├── app_theme.dart           # ✓ Updated to use all constants
└── README.md                # Full documentation
```

## 🎨 Quick Usage Examples

### Colors
```dart
import 'package:market_management_flutter/core/constants/app_colors.dart';

// Primary colors
Container(color: AppColors.primary)
Container(color: AppColors.secondary)

// KPI colors
KpiCard(color: AppColors.electricity)  // Orange
KpiCard(color: AppColors.amount)       // Blue
KpiCard(color: AppColors.acCost)       // Cyan
KpiCard(color: AppColors.serviceCost)  // Green

// Text colors
Text('Hello', style: TextStyle(color: AppColors.textPrimary))
Text('Subtitle', style: TextStyle(color: AppColors.textSecondary))

// Semantic colors
Icon(Icons.check, color: AppColors.success)
Icon(Icons.warning, color: AppColors.warning)
Icon(Icons.error, color: AppColors.error)
```

### Sizes
```dart
import 'package:market_management_flutter/core/constants/app_sizes.dart';

// Padding
Padding(padding: EdgeInsets.all(AppSizes.padding))        // 16px
Padding(padding: EdgeInsets.all(AppSizes.paddingXL))      // 24px

// Border radius
BorderRadius.circular(AppSizes.radius)      // 12px (cards)
BorderRadius.circular(AppSizes.radiusMD)    // 8px (buttons)

// Spacing
SizedBox(height: AppSizes.space)     // 16px
SizedBox(height: AppSizes.spaceLG)   // 24px

// Elevation
Card(elevation: AppSizes.elevationSM)  // 2

// Icons
Icon(Icons.star, size: AppSizes.icon)    // 24px
Icon(Icons.star, size: AppSizes.iconLG)  // 32px
```

### Text Styles
```dart
import 'package:market_management_flutter/core/constants/app_text_styles.dart';

// Headers
Text('Page Title', style: AppTextStyles.headlineLarge)
Text('Section', style: AppTextStyles.titleMedium)

// Body text
Text('Content', style: AppTextStyles.bodyMedium)
Text('Small text', style: AppTextStyles.bodySmall)

// KPI cards
Text('12,345', style: AppTextStyles.kpiValue)
Text('Total Amount', style: AppTextStyles.kpiTitle)

// Buttons
Text('Click Me', style: AppTextStyles.buttonText)

// With color modification
Text(
  'Error',
  style: AppTextStyles.withColor(
    AppTextStyles.bodyMedium,
    AppColors.error,
  ),
)
```

### App Constants
```dart
import 'package:market_management_flutter/core/constants/app_constants.dart';

// Date formatting
DateFormat(AppConstants.displayDateFormat)  // "Jan 15, 2025"
DateFormat(AppConstants.periodFormat)       // "2025-01"

// Currency
NumberFormat.currency(symbol: AppConstants.currencySymbol)

// Error messages
Text(AppConstants.errorNetwork)
Text(AppConstants.successSaved)

// Animation duration
Duration(milliseconds: AppConstants.animationDuration)  // 300ms

// Validation
if (password.length < AppConstants.minPasswordLength) {
  // Error
}
```

## 🎯 Common Patterns

### Card with Padding
```dart
Card(
  elevation: AppSizes.elevationSM,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSizes.radius),
  ),
  child: Padding(
    padding: EdgeInsets.all(AppSizes.padding),
    child: Text(
      'Card Content',
      style: AppTextStyles.bodyMedium,
    ),
  ),
)
```

### Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    padding: EdgeInsets.symmetric(
      horizontal: AppSizes.paddingXL,
      vertical: AppSizes.paddingMD,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMD),
    ),
  ),
  onPressed: () {},
  child: Text('Button', style: AppTextStyles.buttonText),
)
```

### Input Field
```dart
TextField(
  style: AppTextStyles.inputText,
  decoration: InputDecoration(
    labelText: 'Email',
    labelStyle: AppTextStyles.inputLabel,
    hintText: 'Enter email',
    hintStyle: AppTextStyles.inputHint,
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMD),
      borderSide: BorderSide(color: AppColors.border),
    ),
  ),
)
```

## 📊 Size Reference Chart

| Name | Value | Use Case |
|------|-------|----------|
| `paddingXS` | 4px | Tight spacing |
| `paddingSM` | 8px | Small gaps |
| `paddingMD` | 12px | Medium gaps |
| `padding` | 16px | **Default/Most common** |
| `paddingLG` | 20px | Large gaps |
| `paddingXL` | 24px | Extra large gaps |
| `paddingXXL` | 32px | Very large gaps |

| Name | Value | Use Case |
|------|-------|----------|
| `radiusXS` | 4px | Small elements |
| `radiusSM` | 6px | Chips, badges |
| `radiusMD` | 8px | **Buttons** |
| `radius` | 12px | **Cards** |
| `radiusLG` | 16px | Large cards |
| `radiusXL` | 20px | Very large elements |

## 🎨 Color Palette

### Primary Colors
- **Primary**: `#1976D2` (Blue)
- **Secondary**: `#0288D1` (Light Blue)
- **Accent**: `#FF6F00` (Orange)

### KPI Colors
- **Electricity**: `#FF9800` (Orange)
- **Amount**: `#1976D2` (Blue)
- **AC Cost**: `#00ACC1` (Cyan)
- **Service**: `#43A047` (Green)
- **Invoice**: `#8E24AA` (Purple)
- **Status**: `#00897B` (Teal)

### Semantic Colors
- **Success**: `#4CAF50` (Green)
- **Warning**: `#FFA726` (Orange)
- **Error**: `#F44336` (Red)
- **Info**: `#2196F3` (Blue)

## 🔄 Migration Steps

1. **Find hardcoded values** in your code
2. **Replace with constants:**

```dart
// Before ❌
padding: EdgeInsets.all(16)
color: Color(0xFF1976D2)
style: TextStyle(fontSize: 14)

// After ✅
padding: EdgeInsets.all(AppSizes.padding)
color: AppColors.primary
style: AppTextStyles.bodyMedium
```

## 💡 Pro Tips

1. **Use Theme Context**
   ```dart
   // Access theme text styles
   Text('Hello', style: Theme.of(context).textTheme.bodyMedium)

   // Access theme colors
   Container(color: Theme.of(context).colorScheme.primary)
   ```

2. **Consistent Spacing**
   ```dart
   // Always use multiples of 4 or 8
   SizedBox(height: AppSizes.space)     // Good ✓
   SizedBox(height: 17)                 // Bad ✗
   ```

3. **KPI Cards**
   ```dart
   // Use predefined KPI colors
   KpiCard(
     color: AppColors.electricity,  // Not Colors.orange
     // ...
   )
   ```

4. **Responsive Design**
   ```dart
   // For mobile/tablet variations
   final isDesktop = MediaQuery.of(context).size.width > 600;
   final padding = isDesktop ? AppSizes.paddingXL : AppSizes.padding;
   ```

## 📝 Notes

- All constants are **centralized** for easy maintenance
- **No magic numbers** - everything has a name
- Easy to **theme** the entire app by changing constants
- Follows **Material Design 3** guidelines
- **Type-safe** - no runtime errors from typos

---

**Ready to use!** Import the constants and start building with a consistent design system. 🎉