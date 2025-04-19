import 'dart:io';
import 'dart:math';
import 'package:englozi/databases/translator_db.dart';
import 'package:englozi/databases/history_db.dart';
import 'package:englozi/features/favourite.dart';
import 'package:englozi/features/history.dart';
import 'package:englozi/model/tra_model.dart';
import 'package:englozi/model/his_model.dart';
import 'package:englozi/pages/pronounciation_page.dart';
import 'package:englozi/pages/word_details_page.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  late DatabaseHelper dbHelper;
  late DatabaseHistory dbHistory;

  List<History> _foundWords = [];
  late List<TranslatorModel> words;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    dbHelper.database;
    dbHistory = DatabaseHistory.instance;
    dbHistory.database;
    getData();
  }

  String? keyword;

  void _filters(String key) async {
    keyword = key;
    List<History> results = [];
    if (keyword!.isEmpty) {
      getData();
    } else {
      results = await dbHistory.searchWords(key);
    }
    setState(() {
      _foundWords = results;
    });
  }

  void getData() async {
    words = await dbHelper.queryAll();
  }

  void randomSearch() async {
    Random random = Random();
    int randomNumber = random.nextInt(words.length);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WordDetails(
          word: words[randomNumber].word,
          noun: words[randomNumber].noun,
          plural: words[randomNumber].plural,
          description: words[randomNumber].description,
          phrase: words[randomNumber].phrase,
          t_verb: words[randomNumber].t_verb,
          i_verb: words[randomNumber].i_verb,
          adjective: words[randomNumber].adjective,
          adverb: words[randomNumber].adverb,
          preposition: words[randomNumber].preposition,
          synonym: words[randomNumber].synonym,
          antonym: words[randomNumber].antonym,
          conjunction: words[randomNumber].conjunction,
        ),
      ),
    );

    _filters(words[randomNumber].word);
    if (_foundWords.isEmpty) {
      await dbHistory.insert(
        History(
          word: words[randomNumber].word,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.68,
      child: Drawer(
        backgroundColor: Colors.white,
        elevation: 0.0,
        child: ListView(
          children: <Widget>[
            // const SizedBox(height: 8.0,),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.volume_up),
                title: Text('Pronunciation'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PronunciationPage(),
                  ),
                );
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 0.0,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.shuffle),
                title: Text('Random word'),
              ),
              onTap: () {
                randomSearch();
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 0.0,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.favorite_outlined),
                title: Text('Favourites'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouritePage(),
                  ),
                );
              },
            ),
            // const Divider(
            //   color: Colors.grey,
            //   height: 0.0,
            // ),
            // InkWell(
            //   child: const ListTile(
            //     iconColor: Colors.teal,
            //     leading: Icon(Icons.settings),
            //     title: Text('Settings'),
            //   ),
            //   onTap: () {},
            // ),
            const Divider(
              color: Colors.grey,
              height: 0.0,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.ad_units),
                title: Text('About'),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.grey,
              height: 0.0,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.help_outline),
                title: Text('Help'),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.grey,
              height: 0.0,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.history),
                title: Text('History'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ),
                );
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 0.0,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.grey,
                leading: Icon(Icons.cancel),
                title: Text('Exit'),
              ),
              onTap: () {
                exit(0);
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 0.0,
            ),
          ],
        ),
      ),
    );
  }
}
