class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';

  // API Version
  static const String apiVersion = '/api/v1';

  // Full API URL
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // Endpoints
  static const String shops = '/shops';
  static const String meters = '/meters';
  static const String readings = '/readings';
  static const String tariffs = '/tariffs';
  static const String monthlyInputs = '/monthly-inputs';
  static const String billing = '/billing';
  static const String invoices = '/invoices';
  static const String reports = '/reports';
  static const String reportsSummary = '/reports/summary';
}