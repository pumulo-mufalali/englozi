import 'package:englozi/databases/dictionary_db.dart';
import 'package:englozi/databases/history_db.dart';
import 'package:englozi/model/dic_model.dart';
import 'package:englozi/model/his_model.dart';
import 'package:englozi/pages/word_details_page.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late DatabaseHistory dbHistory;
  late DatabaseHelper dbHelper;

  List<History> words = [];

  @override
  void initState() {
    super.initState();
    dbHistory = DatabaseHistory.instance;
    dbHistory.database;

    dbHelper = DatabaseHelper.instance;
    dbHelper.database;
    getData();
  }

  void getData() async {
    List<History> result = await dbHistory.queryAll();
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

  void _delete(BuildContext context, History history) async {
    int result = await dbHistory.delete(history.id!);
    if (result != 0) {
      _showSnackBar(context, 'Deleted');
    }
    updateHistoryList();
  }

  void _deleteAll(BuildContext context, History history) async {
    await dbHistory.deleteAll(history.id!);
    updateHistoryList();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateHistoryList() {
    Future<List<History>> historyFuture = dbHistory.queryAll();
    historyFuture.then((value) {
      setState(() {
        words = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text('History'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_delete),
            onPressed: () async {
              words.isNotEmpty
                  ? showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Delete",
                            style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            "Are you sure you want to delete all",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          actions: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.white) //<-- SEE HERE
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
                                _showSnackBar(context, 'Deleted all');

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
                          content: const Text("No content in history"),
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
              itemCount: words.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.grey,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      0.0,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      words[words.length - (index + 1)].word,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: GestureDetector(
                      child: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
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
                  ),
                );
              })
          : const Center(
              child: Text(
                'No item',
                // style: TextStyle(
                //   fontStyle: FontStyle.italic,
                // ),
              ),
            ),
    );
  }
}