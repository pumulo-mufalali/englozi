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

  bool isSwitched = false;

  void speakEnglish(String text) async {
    await flutterTts.stop();
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("en");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  void speakLozi(String text) async {
    await flutterTts.stop();
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("sw");
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
        actions: [
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(
                      () {
                    isSwitched = value;
                  },
                );
              },
              activeColor: Colors.tealAccent,
            ),
          ),
        ],
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
                  isSwitched ? speakEnglish(txtController.text) : speakLozi(txtController.text);
                },
                child: const Icon(Icons.volume_up, color: Colors.white,))
          ],
        ),
      ),
    );
  }
}
