import 'package:englozi/databases/db.dart';
import 'package:englozi/databases/dictionary_db.dart';
import 'package:englozi/model/dic_model.dart';
import 'package:englozi/pages/word_details_page.dart';
import 'package:flutter/material.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  late DatabaseHelper dbHelper;

  List<DictionaryModel> words = [];

  bool fetching = true; // show circularProgress if still fetching

  @override
  void initState() {
    super.initState();

    dbHelper = DatabaseHelper.instance;
    dbHelper.database;
    getData();
  }

  void getData() async {
    words = await dbHelper.queryAll();
    setState(() {
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
        centerTitle: true,
        elevation: 0,
        // icon: Icon(Icons.list),
      ),
      body: Center(
        // words.isNotEmpty ? words[0].word! : ''
        child : Text(words[2].word),
      ),
    );
  }
}
