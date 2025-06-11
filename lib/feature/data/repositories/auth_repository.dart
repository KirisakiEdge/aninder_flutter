import 'package:aninder/core/network/dio_client.dart';
import 'package:aninder/feature/data/models/requests/AuthRequest.dart';
import 'package:dio/dio.dart';
import 'auth_interface.dart';

class AuthRepository extends AuthRepositoryInterface {
  final DioClient _dioClient;

  AuthRepository({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Response> auth(String code) async {
    try {
      final response = _dioClient.dio
          .post("oauth/token", data: AuthRequest(code: code).toJson());
      return response;
    } catch (e) {
      throw AuthException("Something went wrong...");
    }
  }
}

class AuthException implements Exception {
  final String code;

  AuthException(this.code);
}
