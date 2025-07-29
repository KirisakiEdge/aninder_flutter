import 'package:aninder/core/network/graphql_client.dart';
import 'package:aninder/feature/data/datasources/auth_local_data_source.dart';
import 'package:aninder/feature/data/repositories/auth_repository.dart';
import 'package:aninder/feature/data/repositories/media_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  // External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Core
  getIt.registerLazySingleton(() => SecureStorageService(getIt()));
  getIt.registerLazySingleton(() => AuthLocalDataSource(getIt()));
  getIt.registerLazySingleton(() => DioClient(storage: getIt(), dio: getIt()));
  final client = await GraphQlClient.create(storage: getIt());
  getIt.registerLazySingleton(() => client);

  // Repositories
  getIt.registerLazySingleton(() => AuthRepository(dioClient: getIt()));
  getIt.registerLazySingleton(() => MediaRepository(graphQlClient: getIt()));
}
