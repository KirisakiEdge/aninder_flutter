import 'package:flutter/material.dart';

class FailureNetworkConnectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
        "Offline ❌\nPlease connect to Ethernet",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red
        ),
      );
  }
}
