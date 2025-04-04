import 'package:aninder/feature/data/datasources/auth_local_data_source.dart';
import 'package:dio/dio.dart';


class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource storage;

  AuthInterceptor({required this.storage});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Retrieve the auth token from secure storage
    String? token = await storage.getToken();

    // Add the headers
    options.headers['Accept'] = 'application/json';

    // If URL contains specific paths like 'version' or 'download', add the 'x-app-token'
    if (options.uri.path.contains('version') || options.uri.path.contains('download')) {
      if (token != null && token.isNotEmpty) {
        options.headers['x-app-token'] = token;
      }
    } else if (token != null && token.isNotEmpty) {
      // Add Bearer token for all other requests
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Proceed with the request
    return super.onRequest(options, handler);
  }
}