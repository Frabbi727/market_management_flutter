import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import 'dart:developer' as developer;

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Add custom logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final uri = options.uri;

          debugPrint('\n');
          debugPrint('╔═══════════════════════════════════════════════════════════════');
          debugPrint('║ 🚀 REQUEST');
          debugPrint('╠═══════════════════════════════════════════════════════════════');
          debugPrint('║ Method: ${options.method}');
          debugPrint('║ URL: $uri');
          debugPrint('║ Base URL: ${ApiConstants.apiBaseUrl}');
          debugPrint('║ Path: ${options.path}');

          if (options.queryParameters.isNotEmpty) {
            debugPrint('║ Query Parameters: ${options.queryParameters}');
          }

          debugPrint('║ Headers:');
          options.headers.forEach((key, value) {
            debugPrint('║   $key: $value');
          });

          if (options.data != null) {
            debugPrint('║ Request Body:');
            debugPrint('║   ${options.data}');
          }

          debugPrint('╚═══════════════════════════════════════════════════════════════\n');

          // Log to developer console as well
          developer.log(
            'REQUEST: ${options.method} $uri',
            name: 'DioClient',
          );

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final uri = response.requestOptions.uri;

          debugPrint('\n');
          debugPrint('╔═══════════════════════════════════════════════════════════════');
          debugPrint('║ ✅ RESPONSE');
          debugPrint('╠═══════════════════════════════════════════════════════════════');
          debugPrint('║ URL: $uri');
          debugPrint('║ Status Code: ${response.statusCode}');
          debugPrint('║ Status Message: ${response.statusMessage}');

          debugPrint('║ Response Headers:');
          response.headers.forEach((key, values) {
            debugPrint('║   $key: ${values.join(', ')}');
          });

          debugPrint('║ Response Data:');
          if (response.data is List) {
            debugPrint('║   [List with ${(response.data as List).length} items]');
            if ((response.data as List).isNotEmpty) {
              debugPrint('║   First item: ${(response.data as List).first}');
            }
          } else if (response.data is Map) {
            debugPrint('║   ${response.data}');
          } else {
            debugPrint('║   ${response.data}');
          }

          debugPrint('╚═══════════════════════════════════════════════════════════════\n');

          // Log to developer console
          developer.log(
            'RESPONSE: ${response.statusCode} - ${response.requestOptions.method} $uri',
            name: 'DioClient',
          );

          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('\n');
          debugPrint('╔═══════════════════════════════════════════════════════════════');
          debugPrint('║ ❌ ERROR');
          debugPrint('╠═══════════════════════════════════════════════════════════════');
          debugPrint('║ URL: ${error.requestOptions.uri}');
          debugPrint('║ Method: ${error.requestOptions.method}');
          debugPrint('║ Error Type: ${error.type}');
          debugPrint('║ Error Message: ${error.message}');

          if (error.response != null) {
            debugPrint('║ Status Code: ${error.response?.statusCode}');
            debugPrint('║ Status Message: ${error.response?.statusMessage}');
            debugPrint('║ Response Data: ${error.response?.data}');
          }

          debugPrint('╚═══════════════════════════════════════════════════════════════\n');

          // Log to developer console
          developer.log(
            'ERROR: ${error.message}',
            name: 'DioClient',
            error: error,
          );

          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

// Riverpod provider for DioClient
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});