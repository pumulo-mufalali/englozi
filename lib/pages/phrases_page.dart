import 'package:englozi/databases/phrases_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/phr_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:englozi/features/help/englozi_switch.dart';

class PhrasesPage extends StatefulWidget {
  const PhrasesPage({Key? key}) : super(key: key);

  @override
  State<PhrasesPage> createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<PhrasesPage> {
  late PhrasesDB _phrasesDB;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _phrasesDB = PhrasesDB.instance;
    _phrasesDB.database;
    getData();

    flutterTts.awaitSpeakCompletion(true);
  }

  List<PhraseDictionary> _foundWords = [];

  String? keyword;

  void _filters(String key) async {
    keyword = key;
    List<PhraseDictionary> results = [];
    if (keyword!.isEmpty) {
      getData();
    } else {
      results = await _phrasesDB.searchWords(key);
    }
    setState(() {
      _foundWords = results;
    });
  }

  void getData() async {
    List<PhraseDictionary> results = [];
    results = await _phrasesDB.queryAll();
    setState(() {
      _foundWords = results;
    });
  }

  final FlutterTts flutterTts = FlutterTts();

  speakLozi(String text) async {
    await flutterTts.stop();
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.awaitSpeakCompletion(true);

    try {
      await flutterTts.setLanguage("sw");
      var result = await flutterTts.speak(text);
      print("Swahili TTS result: $result");

      if (result != 0) {
        print("Swahili failed. Using English voice.");
        await flutterTts.setLanguage("en");
        await flutterTts.speak(text);
      }
    } catch (e) {
      print("TTS Error: $e");
    }
    return await flutterTts.speak(text);
  }


  speakEnglish(String text) async {
    await flutterTts.stop();
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("en");
    await flutterTts.setVoice({"name": "en-us-x-sfg#male_1-local", "locale": "en-US"});
    await flutterTts.setSpeechRate(0.4);
    return await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    keyword ??= '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('Phrases'),
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
              activeColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Scaffold(
        drawer: const DrawerPage(),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => _filters(value),
                cursorColor: Colors.black87,
                decoration: InputDecoration(
                  hintText: 'Easy access...',
                  labelStyle: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.normal,
                    fontSize: 25,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EngloziSwitch(),
                        ),
                      ),
                    },
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _foundWords.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Card(
                        color: Colors.white60,
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: 'Eng: ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.5,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: _foundWords[index]
                                          .phrEnglish[0]
                                          .toUpperCase() +
                                      _foundWords[index]
                                          .phrEnglish
                                          .substring(1),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              text: 'Lozi: ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.5,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: _foundWords[index]
                                          .phrSilozi[0]
                                          .toUpperCase() +
                                      _foundWords[index].phrSilozi.substring(1),
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: InkWell(
                            child: const Icon(
                              Icons.volume_up,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              if (isSwitched == true) {
                                speakLozi(_foundWords[index].phrSilozi);
                              } else {
                                speakEnglish(_foundWords[index].phrEnglish);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
