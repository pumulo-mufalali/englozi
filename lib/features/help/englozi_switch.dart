import 'package:flutter/material.dart';

class EngloziSwitch extends StatelessWidget {
  const EngloziSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch guide'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Card(
          elevation: 0.0,
            child: Padding(
              padding: EdgeInsets.all(12.5),
              child: Text(
                'Turn on the switch '
                    'on top if u '
                    'want to hear the sentence in lozi',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey
                ),
              ),
            ),
          ),
      ),
    );
  }
}
