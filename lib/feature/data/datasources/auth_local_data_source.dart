import '../../../core/storage/secure_storage_service.dart';

class AuthLocalDataSource {
  final SecureStorageService _storage;

  AuthLocalDataSource(this._storage);

  Future<void> cacheToken(String token) async {
    await _storage.write('auth_token', token);
  }

  Future<String?> getToken() async {
    return await _storage.read('auth_token');
  }
  Future<void> clearToken() async {
    await _storage.delete('auth_token');
  }
}