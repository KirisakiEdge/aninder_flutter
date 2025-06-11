import 'package:aninder/feature/ui/elements/FailureNetworkConnectionWidget.dart';
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

  @override
  void initState() {
    super.initState();
    networkMonitor.networkStatus.listen((state) {
      if (state) {
        if (widget.authCode != null) {
          widget.viewModel.getToken(widget.authCode!);
        }
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
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      PopupMenuButton<String>(
                        constraints: const BoxConstraints.expand(
                            width: 100, height: 200),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        offset: const Offset(0, 60),
                        onSelected: viewModel.selectYear,
                        itemBuilder: (BuildContext context) {
                          return viewModel.yearEntries;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            viewModel.currentYear.toString(),
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          viewModel.goToFeedScreen(context);
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
