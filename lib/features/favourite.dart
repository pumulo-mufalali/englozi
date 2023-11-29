import 'package:englozi/databases/dictionary_db.dart';
import 'package:englozi/databases/favourite_db.dart';
import 'package:englozi/model/dic_model.dart';
import 'package:englozi/model/fav_model.dart';
import 'package:englozi/pages/word_details_page.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late DatabaseFavourite dbFavourite;
  late DatabaseHelper dbHelper;

  List<Favourite> words = [];

  @override
  void initState() {
    super.initState();
    dbFavourite = DatabaseFavourite.instance;
    dbFavourite.database;

    dbHelper = DatabaseHelper.instance;
    dbHelper.database;
    getData();
  }

  void getData() async {
    List<Favourite> result = await dbFavourite.queryAll();
    setState(() {
      words = result;
    });
  }

  List<DictionaryModel> _foundWords = [];

  _filters(String? key) async {
    List<DictionaryModel> results = [];
    if (key!.isEmpty) {
      results = [];
    } else {
      results = await dbHelper.searchWords(key);
    }
    setState(() {
      _foundWords = results;
    });
  }

  void _delete(BuildContext context, Favourite favourite) async {
    int result = await dbFavourite.delete(favourite.id!);
    if (result != 0) {
      _showSnackBar(context, 'Cleared');
    }
    updateFavouriteList();
  }

  void _deleteAll(BuildContext context, Favourite favourite) async {
    await dbFavourite.deleteAll(favourite.id!);
    updateFavouriteList();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateFavouriteList() {
    Future<List<Favourite>> favouriteFuture = dbFavourite.queryAll();
    favouriteFuture.then((value) {
      setState(() {
        words = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text('Favourite'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              // _showSnackBar(context, 'Clearing all');

              words.isNotEmpty
                  ? showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Clearing",
                            style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            "Are you sure you want to clear all",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          actions: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                              ),
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white)),
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              onPressed: () {
                                for (int i = 0; i < words.length; i++) {
                                  _deleteAll(context, words[i]);
                                }
                                _showSnackBar(context, 'Cleared all');

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          elevation: 12.0,
                          backgroundColor: Colors.white,
                        );
                      },
                    )
                  : showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Sorry!!!"),
                          content: const Text("No content in favourite"),
                          actions: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.white) //<-- SEE HERE
                                  ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            )
                          ],
                        );
                      });
            },
          ),
        ],
      ),
      body: words.isNotEmpty
          ? ListView.builder(
              addRepaintBoundaries: false,
              itemCount: words.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(words[words.length - (index + 1)].word),
                  trailing: GestureDetector(
                    child: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      _delete(context, words[words.length - (index + 1)]);
                    },
                  ),
                  onTap: () async {
                    int id = words.length - (index + 1);
                    await _filters(words[id].word);
                    _foundWords[0].word == words[id].word
                        ? Navigator.of(context).push(
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
                          )
                        : await _filters(words[id].word);
                  },
                );
              })
          : const Center(
              child: Text('No item'),
            ),
    );
  }
}
