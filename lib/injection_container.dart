import 'package:aninder/feature/data/datasources/auth_local_data_source.dart';
import 'package:aninder/feature/data/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> initGetIn() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Core
  sl.registerLazySingleton(() => SecureStorageService(sl()));
  sl.registerLazySingleton(() => AuthLocalDataSource(sl()));
  sl.registerLazySingleton(() => DioClient(storage: sl(), dio: sl()));

  // Repositories
  sl.registerLazySingleton(() => AuthRepository(dioClient: sl()));
}
