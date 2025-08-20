
import 'package:aninder/core/utils/NetworkMonitor.dart';
import 'package:aninder/feature/ui/elements/FailureNetworkConnectionWidget.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final networkMonitor = NetworkMonitor().networkStatus;
    bool isNetworkConnected = true;
    networkMonitor.listen((value) {
      isNetworkConnected = value;
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isNetworkConnected)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(width: 2, color: Colors.grey),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () async {
                  },
                  child: const Text('Log In'),
                )
              else
                FailureNetworkConnectionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
