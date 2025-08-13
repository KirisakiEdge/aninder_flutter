import 'package:aninder/Routes.dart';
import 'package:aninder/feature/data/datasources/auth_local_data_source.dart';
import 'package:aninder/feature/data/models/response/AuthResponse.dart';
import 'package:aninder/feature/data/repositories/auth_repository.dart';
import 'package:aninder/feature/data/repositories/general_repository.dart';
import 'package:aninder/graphql/get_genre_tag_list.graphql.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class HomeViewModel extends ChangeNotifier {
  AuthRepository authRepository = GetIt.instance<AuthRepository>();
  GeneralRepository generalRepository = GetIt.instance<GeneralRepository>();
  AuthLocalDataSource dataStorage = GetIt.instance<AuthLocalDataSource>();

  HomeViewModel() {
  }

  Future<String> getToken(String code) async {
    Response response = await authRepository.auth(code);
    dataStorage.cacheToken(AuthResponse.fromJson(response.data).access_token);
    return dataStorage.getToken() as Future<String>;
  }

  Future<Query$GetGenreAndTagLists?> getGenreList() async {
    final response = await generalRepository.getGenreTagList();
    return response;
  }

  void goToFeedScreen(BuildContext context, int selectedYear,
      List<String> selectedGenre, List<String> selectedTags) {
    final extra = {
      "selectedGenres": selectedGenre,
      "selectedTags": selectedTags,
      "currentYear": selectedYear
    };
    context.push(Routes.FEED.name, extra: extra);
  }
}
