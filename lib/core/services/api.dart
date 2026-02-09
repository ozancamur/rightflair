import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rightflair/core/services/supabase.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';

class ApiService extends SupabaseService {
  static final ApiService _instance = ApiService._internal();
  late final Dio dio;

  factory ApiService() => _instance;

  ApiService._internal();

  void init({required String BASE_URL}) {
    dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Auth token interceptor - her istekte güncel token'ı ekler
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = client.auth.currentSession?.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    // İsteğe bağlı olarak interceptor'lar eklenebilir
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  // GET Method
  Future<Response?> get(
    Endpoint endpoint, {
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.get(
        endpoint.value,
        data: data,
        queryParameters: parameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // POST Method
  Future<Response?> post(
    Endpoint endpoint, {
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.post(
        endpoint.value,
        data: data,
        queryParameters: parameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // PUT Method
  Future<Response?> put(
    Endpoint endpoint, {
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.put(
        endpoint.value,
        data: data,
        queryParameters: parameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // DELETE Method
  Future<Response?> delete(
    Endpoint endpoint, {
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await dio.delete(
        endpoint.value,
        data: data,
        queryParameters: parameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
