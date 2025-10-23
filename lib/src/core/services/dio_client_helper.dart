import 'package:dio/dio.dart';
import 'dart:io';

import '../consts/api_routs.dart';
import '../helpers/token_staorage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(
        seconds: 30,
      ), // Fixed: 5000 seconds is too long
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  DioClient() {
    // Initialize HttpOverrides
    HttpOverrides.global = MyHttpOverrides();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add access token to header
          final String? token = await TokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // If token is expired, refresh token
          if (error.response?.statusCode == 401) {
            try {
              await _refreshToken();

              // Update the original request with the new token
              final String? newToken = await TokenStorage.getAccessToken();
              if (newToken != null) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';

                // Retry the failed request
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              }
            } on DioException catch (e) {
              // Handle error during refresh
              return handler.reject(e);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Enhanced refresh token function
  Future<void> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await _dio.post(
        '$baseURL/auth/refresh/', // Use your actual refresh endpoint
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await TokenStorage.saveTokens(data['access'], data['refresh']);
      } else {
        throw Exception('Failed to refresh token');
      }
    } on DioException catch (e) {
      // Clear tokens if refresh fails
      await TokenStorage.clearTokens();
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final errorData = e.response!.data;

      switch (statusCode) {
        case 400:
          return Exception(errorData['message'] ?? 'Bad request');
        case 401:
          return Exception('Unauthorized - Please login again');
        case 403:
          return Exception('Access denied');
        case 404:
          return Exception('Resource not found');
        case 500:
          return Exception('Server error - Please try again later');
        default:
          return Exception(errorData['message'] ?? 'Unknown error occurred');
      }
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timeout - Please check your internet');
        case DioExceptionType.badCertificate:
          return Exception('Security certificate error');
        case DioExceptionType.badResponse:
          return Exception('Invalid server response');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        case DioExceptionType.connectionError:
          return Exception('No internet connection');
        case DioExceptionType.unknown:
          return Exception('Network error - Please try again');
      }
    }
  }
}
