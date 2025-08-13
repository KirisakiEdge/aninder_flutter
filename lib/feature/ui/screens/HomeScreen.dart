import 'package:aninder/feature/ui/elements/FailureNetworkConnectionWidget.dart';
import 'package:aninder/feature/ui/elements/SearchableGenreTagDropdown.dart';
import 'package:aninder/feature/ui/viewmodels/HomeViewModel.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/NetworkMonitor.dart';

class HomeScreen extends StatefulWidget {
  String? authCode;
  HomeViewModel viewModel = HomeViewModel();

  HomeScreen({this.authCode, super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomeScreen> {
  NetworkMonitor networkMonitor = NetworkMonitor();
  bool isNetworkConnected = false;
  int selectedYear = DateTime.now().year;
  List<PopupMenuEntry<String>>? yearEntries;
  List<String> genresList = [];
  List<String> tagList = [];
  List<String> selectedGenresList = [];
  List<String> selectedTagList = [];

  @override
  void initState() {
    super.initState();
    final years =
        List.generate(selectedYear - 1990 + 1, (index) => (1990 + index));
    yearEntries = years.map((year) {
      return PopupMenuItem<String>(
        value: year.toString(),
        child: Text(year.toString()),
      );
    }).toList();
    networkMonitor.networkStatus.listen((state) async {
      if (state) {
        if (widget.authCode != null) {
          widget.viewModel.getToken(widget.authCode!);
        }
        final response = await widget.viewModel.getGenreList();
        genresList = response?.GenreCollection ?? [];
        tagList =
            response?.MediaTagCollection?.map((item) => item!.name).toList() ??
                [];
      }
      setState(() {
        isNetworkConnected = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 200, left: 24, right: 24),
          child: isNetworkConnected == true
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Choose a year from which anime search will start',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      PopupMenuButton<String>(
                        constraints: const BoxConstraints.expand(
                            width: 100, height: 200),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        offset: const Offset(0, 60),
                        onSelected: (year) {
                          setState(() {
                            selectedYear = int.parse(year);
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return yearEntries!;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            selectedYear.toString(),
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SearchableGenreTagDropdown(
                          genres: genresList,
                          tags: tagList,
                          labelText: "Choose Genres or Tags",
                          trailingIcon: Icons.arrow_drop_down,
                          onSelectedListChanged: (selectedGenre, selectedTags) {
                            setState(() {
                              selectedGenresList = selectedGenre;
                              selectedTagList = selectedTags;
                            });
                          },
                          onDoneClick:
                              (searchText, selectedGenre, selectedTags) {
                            setState(() {
                              selectedGenresList = selectedGenre;
                              selectedTagList = selectedTags;
                            });
                          }),
                      const SizedBox(height: 24),
                      OutlinedButton(
                        onPressed: () {
                          viewModel.goToFeedScreen(context, selectedYear,
                              selectedGenresList, selectedTagList);
                        },
                        style: OutlinedButton.styleFrom(
                          side:
                              const BorderSide(color: Colors.grey, width: 2.0),
                          foregroundColor: Colors.white70,
                        ).copyWith(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                        child: const Text("GET STARTED"),
                      ),
                    ],
                  ),
                )
              : FailureNetworkConnectionWidget(),
        ),
      ),
    );
  }
}
