import 'package:aninder/feature/data/datasources/auth_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:aninder/core/network/interceptors/auth_interceptor.dart';

class DioClient {
  final Dio dio;
  final AuthLocalDataSource _storage;

  DioClient({required AuthLocalDataSource storage, required this.dio})
      : _storage = storage {
    dio
      ..options.baseUrl = 'https://anilist.co/api/v2/'
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 10)
      ..interceptors.add(AuthInterceptor(storage: _storage))
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
  }

// Add generic request methods if needed
}
