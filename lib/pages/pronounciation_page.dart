import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PronunciationPage extends StatefulWidget {
  const PronunciationPage({Key? key}) : super(key: key);

  @override
  State<PronunciationPage> createState() => _PronunciationPageState();
}

class _PronunciationPageState extends State<PronunciationPage> {
  final FlutterTts flutterTts = FlutterTts();
  TextEditingController txtController = TextEditingController();

  void speak(String text) async {
    await flutterTts.setPitch(0.1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text('Pronunciation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: txtController,
              decoration: const InputDecoration(
                  hintText: 'write here',
                  floatingLabelAlignment: FloatingLabelAlignment.center),
              style: const TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  speak(txtController.text);
                },
                child: const Icon(Icons.volume_up, color: Colors.white,))
          ],
        ),
      ),
    );
  }
}
