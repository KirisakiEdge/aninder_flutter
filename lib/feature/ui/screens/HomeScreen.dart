import 'package:flutter/material.dart';

import '../../../injection_container.dart';
import '../../data/datasources/auth_local_data_source.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthLocalDataSource _storage = sl();
  bool yearsDropdownExpanded = false;
  int _currentYear = 2000;

  late final List<int> years;
  late final List<PopupMenuEntry<String>> yearEntries;

  @override
  void initState() {
    super.initState();
    years = List.generate(2025 - 1990 + 1, (index) => (1990 + index));
    yearEntries = years.map((year) {
      return PopupMenuItem<String>(
        value: year.toString(),
        child: Text(year.toString()),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 200, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Choose a year from which anime search will start',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              PopupMenuButton<String>(
                constraints:
                    const BoxConstraints.expand(width: 100, height: 200),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                offset: const Offset(0, 60),
                onSelected: (String result) {
                  setState(() {
                    _currentYear = int.parse(result);
                  });
                },
                itemBuilder: (BuildContext context) {
                  return yearEntries;
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Set the background color
                    borderRadius: BorderRadius.circular(
                        15.0), // Set the border radius for rounded corners
                  ),
                  child: Text(
                    _currentYear.toString(),
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 2.0), // Set the border color and width
                    foregroundColor: Colors.white70
                  ).copyWith(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0), // Set the border radius for rounded corners
                      ),
                    ),
                  ),
                  child: const Text("GET STARTED"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
