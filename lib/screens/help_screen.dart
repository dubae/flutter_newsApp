import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.blueGrey.shade300,
          title: const Text(
            '도움말',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          )),
      body: const Text("help"),
    );
  }
}
