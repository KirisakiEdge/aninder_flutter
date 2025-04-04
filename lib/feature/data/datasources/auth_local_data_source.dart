import '../../../core/storage/secure_storage_service.dart';

class AuthLocalDataSource {
  final SecureStorageService storage;

  AuthLocalDataSource(this.storage);

  Future<void> cacheToken(String token) async {
    await storage.write('auth_token', token);
  }

  Future<String?> getToken() async {
    return await storage.read('auth_token');
  }
  Future<void> clearToken() async {
    await storage.delete('auth_token');
  }
}