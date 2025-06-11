abstract class AuthRepositoryInterface {
  Future<void> auth(String code);
}