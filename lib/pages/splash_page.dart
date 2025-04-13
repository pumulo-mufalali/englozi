import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'Eng',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 57.0,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'lozi',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 57.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}