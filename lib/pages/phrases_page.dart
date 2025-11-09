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

  void speakLozi(String text) async {
    await flutterTts.stop();
    // await flutterTts.setPitch(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("sw");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  speakEnglish(String text) async {
    await flutterTts.stop();
    await flutterTts.setPitch(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("en");
    await flutterTts.setSpeechRate(0.4);
    return await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    keyword ??= '';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        elevation: 0.0,
        title: const Row(
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Phrases'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  isSwitched ? Icons.translate_rounded : Icons.language_rounded,
                  size: 18,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeColor: theme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _filters(value),
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search phrases...',
                hintStyle: TextStyle(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.primaryColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.help_outline_rounded,
                    color: theme.primaryColor.withOpacity(0.7),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EngloziSwitch(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _foundWords.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'ENG',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _foundWords[index].phrEnglish[0]
                                          .toUpperCase() +
                                      _foundWords[index]
                                          .phrEnglish
                                          .substring(1),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'LOZI',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6366F1),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _foundWords[index].phrSilozi[0]
                                          .toUpperCase() +
                                      _foundWords[index].phrSilozi.substring(1),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.volume_up_rounded,
                            color: theme.primaryColor,
                          ),
                          onPressed: () {
                            if (isSwitched != true) {
                              speakEnglish(_foundWords[index].phrEnglish);
                            } else {
                              speakLozi(_foundWords[index].phrSilozi);
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
    );
  }
}
