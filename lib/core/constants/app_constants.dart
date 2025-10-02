class AppConstants {
  // App Info
  static const String appName = 'Market Management';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const int animationDurationShort = 150; // milliseconds
  static const int animationDuration = 300;
  static const int animationDurationLong = 500;

  // Network Timeouts
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy hh:mm a';
  static const String monthYearFormat = 'MMMM yyyy';
  static const String periodFormat = 'yyyy-MM';

  // Currency
  static const String currencySymbol = 'TK';
  static const String currencyFormat = 'TK #,##0.00';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;

  // Debounce & Throttle
  static const int searchDebounceTime = 500; // milliseconds
  static const int buttonThrottleTime = 1000;

  // Grid/Layout
  static const int dashboardGridColumns = 3;
  static const double dashboardCardAspectRatio = 2.0;

  // Snackbar Duration
  static const int snackbarDurationShort = 2; // seconds
  static const int snackbarDuration = 4;
  static const int snackbarDurationLong = 6;

  // Cache
  static const int cacheExpirationMinutes = 60;
  static const int maxCacheSize = 100; // MB

  // Local Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorUnauthorized = 'Session expired. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorServer = 'Server error. Please try again later.';

  // Success Messages
  static const String successSaved = 'Saved successfully';
  static const String successDeleted = 'Deleted successfully';
  static const String successUpdated = 'Updated successfully';
  static const String successCreated = 'Created successfully';

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[0-9]{10,15}$';
  static const String numberPattern = r'^[0-9]+$';
  static const String decimalPattern = r'^[0-9]*\.?[0-9]+$';

  // App Limits
  static const int maxFileUploadSizeMB = 10;
  static const int maxImageUploadSizeMB = 5;
  static const int maxBulkImportRows = 1000;
}