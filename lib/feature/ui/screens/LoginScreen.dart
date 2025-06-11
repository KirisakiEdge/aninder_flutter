
import 'package:aninder/core/utils/NetworkMonitor.dart';
import 'package:aninder/feature/ui/elements/FailureNetworkConnectionWidget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const clientId = '24154';
    const redirectUri = 'aninder://callback';
    const authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code';
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
                    Uri uri = Uri.parse(authUrl);
                    if (!await launchUrl(uri)) {
                      throw Exception('Could not launch $authUrl');
                    }
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
