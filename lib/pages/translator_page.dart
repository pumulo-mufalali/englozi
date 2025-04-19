import 'package:englozi/databases/translator_db.dart';
import 'package:englozi/databases/history_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/tra_model.dart';
import 'package:englozi/model/his_model.dart';
import 'package:englozi/pages/pronounciation_page.dart';
import 'package:englozi/pages/word_details_page.dart';
import 'package:englozi/welcome_page.dart';
import 'package:flutter/material.dart';

import '../features/bottom_navbar.dart';
import '../features/favourite.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({Key? key}) : super(key: key);

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  late DatabaseHelper dbHelper;
  late DatabaseHistory dbHistory;


  int _currentIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FavouritePage()));
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PronunciationPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    dbHelper.database;

    dbHistory = DatabaseHistory.instance;
    dbHistory.database;
  }

  List<TranslatorModel> _foundWords = [];

  String? keyword;

  void _filters(String key) async {
    keyword = key;
    List<TranslatorModel> results = [];
    if (keyword!.isEmpty) {
      results = [];
    } else {
      results = await dbHelper.searchWords(key);
    }
    setState(() {
      _foundWords = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    keyword ??= '';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomePage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Translator'),
        elevation: 0,
        // icon: Icon(Icons.list),
      ),
      body: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        drawer: const DrawerPage(),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) async {
                    if (keyword!.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WordDetails(
                              word: _foundWords[0].word,
                              noun: _foundWords[0].noun,
                              plural: _foundWords[0].plural,
                              description: _foundWords[0].description,
                              phrase: _foundWords[0].phrase,
                              verb: _foundWords[0].verb,
                              t_verb: _foundWords[0].t_verb,
                              i_verb: _foundWords[0].i_verb,
                              adjective: _foundWords[0].adjective,
                              adverb: _foundWords[0].adverb,
                              preposition: _foundWords[0].preposition,
                              synonym: _foundWords[0].synonym,
                              antonym: _foundWords[0].antonym,
                              conjunction: _foundWords[0].conjunction),
                        ),
                      );
                      await dbHistory.insert(
                        History(
                          word: _foundWords[0].word,
                        ),
                      );
                    }
                  },
                  onChanged: (value) {
                    _filters(value);
                  },
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          35.0,
                        ),
                      ),
                    ),
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        if (keyword!.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WordDetails(
                                word: _foundWords[0].word,
                                noun: _foundWords[0].noun,
                                plural: _foundWords[0].plural,
                                description: _foundWords[0].description,
                                phrase: _foundWords[0].phrase,
                                verb: _foundWords[0].verb,
                                t_verb: _foundWords[0].t_verb,
                                i_verb: _foundWords[0].i_verb,
                                adjective: _foundWords[0].adjective,
                                adverb: _foundWords[0].adverb,
                                preposition: _foundWords[0].preposition,
                                synonym: _foundWords[0].synonym,
                                antonym: _foundWords[0].antonym,
                                conjunction: _foundWords[0].conjunction,
                              ),
                            ),
                          );

                          await dbHistory.insert(
                            History(
                              word: _foundWords[0].word,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                // Expanded(child:
                _foundWords.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          color: Colors.white,
                          height: 780,
                          width: 300,
                          child: ListView.builder(
                            shrinkWrap: false,
                            itemCount: _foundWords.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white70,
                                elevation: .2,
                                child: ListTile(
                                  title: Text(
                                    _foundWords[index].word,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => WordDetails(
                                          word: _foundWords[index].word,
                                          noun: _foundWords[index].noun,
                                          plural: _foundWords[index].plural,
                                          description:
                                              _foundWords[index].description,
                                          phrase: _foundWords[index].phrase,
                                          verb: _foundWords[index].verb,
                                          t_verb: _foundWords[index].t_verb,
                                          i_verb: _foundWords[index].i_verb,
                                          adjective:
                                              _foundWords[index].adjective,
                                          adverb: _foundWords[index].adverb,
                                          preposition:
                                              _foundWords[index].preposition,
                                          synonym: _foundWords[index].synonym,
                                          antonym: _foundWords[index].antonym,
                                          conjunction:
                                              _foundWords[index].conjunction,
                                        ),
                                      ),
                                    );

                                    await dbHistory.insert(
                                      History(
                                        word: _foundWords[index].word,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : keyword!.isNotEmpty
                        ? const Center(
                            child: Text(
                              '\n\nWord not available yet',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18.5),
                            ),
                          )
                        : const Text(''),
                // )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
