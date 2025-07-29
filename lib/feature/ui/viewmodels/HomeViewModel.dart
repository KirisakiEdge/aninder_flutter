import 'package:aninder/Routes.dart';
import 'package:aninder/feature/data/datasources/auth_local_data_source.dart';
import 'package:aninder/feature/data/models/response/AuthResponse.dart';
import 'package:aninder/feature/data/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class HomeViewModel extends ChangeNotifier {
  bool yearsDropdownExpanded = false;
  int _currentYear = 2000;
  List<String> _selectedGenres = [];
  List<String> _selectedTags = [];
  final List<int> years =
      List.generate(2025 - 1990 + 1, (index) => (1990 + index));
  List<PopupMenuEntry<String>>? formattedYears;

  int get currentYear => _currentYear;

  List<String> get selectedGenres => _selectedGenres;

  List<String> get selectedTags => _selectedTags;

  AuthRepository authRepository = GetIt.instance<AuthRepository>();
  AuthLocalDataSource dataStorage = GetIt.instance<AuthLocalDataSource>();

  HomeViewModel() {
    formattedYears = years.map((year) {
      return PopupMenuItem<String>(
        value: year.toString(),
        child: Text(year.toString()),
      );
    }).toList();
  }

  Future<String> getToken(String code) async {
    Response response = await authRepository.auth(code);
    dataStorage.cacheToken(AuthResponse.fromJson(response.data).access_token);
    return dataStorage.getToken() as Future<String>;
  }

  List<PopupMenuEntry<String>> get yearEntries {
    return formattedYears!;
  }

  void selectYear(String year) {
    _currentYear = int.parse(year);
    notifyListeners();
  }

  void goToFeedScreen(BuildContext context) {
    selectedGenres.add("Action");
    selectedTags.add("Urban");
    final extra = {
      "selectedGenres": selectedGenres,
      "selectedTags": selectedTags,
      "currentYear": currentYear
    };
    context.go(Routes.FEED.name, extra: extra);
  }
}
