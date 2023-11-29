import 'package:englozi/databases/phrases_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/phr_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PhrasesPage extends StatefulWidget {
  const PhrasesPage({Key? key}) : super(key: key);

  @override
  State<PhrasesPage> createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<PhrasesPage> {
  late PhrasesDB _phrasesDB;

  @override
  void initState() {
    super.initState();
    _phrasesDB = PhrasesDB.instance;
    _phrasesDB.database;
    getData();
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

  void speak(String text) async {
    await flutterTts.setPitch(0.1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    keyword ??= '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Phrases'),
        centerTitle: true,
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
                  prefixIcon: const Icon(
                    Icons.zoom_in_map,
                    color: Colors.green,
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
                                fontSize: 18.5,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: _foundWords[index]
                                      .phrEnglish[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 15.5,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: _foundWords[index].phrEnglish.substring(
                                      1, _foundWords[index].phrEnglish.length),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 15.5,
                                    fontStyle: FontStyle.normal,
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
                                fontSize: 18.5,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: _foundWords[index]
                                      .phrSilozi[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.5,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: _foundWords[index].phrSilozi.substring(
                                      1, _foundWords[index].phrSilozi.length),
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.5,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                          trailing: InkWell(
                            child: const Icon(
                              Icons.volume_up,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              speak(_foundWords[index].phrEnglish);
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
