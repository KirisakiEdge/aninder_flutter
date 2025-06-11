
import 'package:aninder/Routes.dart';
import 'package:flutter/material.dart';

class FeedViewModel extends ChangeNotifier {
  bool yearsDropdownExpanded = false;
  int _currentYear = 2000;
  final List<int> years = List.generate(2025 - 1990 + 1, (index) => (1990 + index));
  List<PopupMenuEntry<String>>? formattedYears;
  int get currentYear => _currentYear;

  FeedViewModel() {
    formattedYears = years.map((year) {
      return PopupMenuItem<String>(
        value: year.toString(),
        child: Text(year.toString()),
      );
    }).toList();
  }

  List<PopupMenuEntry<String>> get yearEntries {
    return formattedYears!;
  }

  void selectYear(String year) {
    _currentYear = int.parse(year);
    notifyListeners();
  }

  void goToFeedScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.FEED.name);
  }
}