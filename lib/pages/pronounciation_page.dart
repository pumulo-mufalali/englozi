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
              onChanged: (value) => setState(() => isSwitched = value),
              activeColor: Colors.tealAccent,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Language indicator at the top
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.translate, color: Colors.teal, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Current Language: ${isSwitched ? 'Lozi':'English'}',
                    style: TextStyle(
                      color: Colors.teal[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 17.5),
                  const Text(
                    '{Turn on the switch for a lozi pronunciation}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17.5,
                    ),
                  )
                ],
              ),
            ),

            // Pronunciation function in the middle
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: txtController,
                      decoration: const InputDecoration(
                        hintText: 'Type text to pronounce',
                        border: OutlineInputBorder(),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        isSwitched
                            ? speakEnglish(txtController.text)
                            : speakLozi(txtController.text);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Pronounce', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}