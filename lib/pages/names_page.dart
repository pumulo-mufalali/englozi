import 'package:englozi/databases/loziname_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/loz_model.dart';
import 'package:flutter/material.dart';

class NamesPage extends StatefulWidget {
  const NamesPage({Key? key}) : super(key: key);

  @override
  State<NamesPage> createState() => _NamesPageState();
}

class _NamesPageState extends State<NamesPage> {
  late LoziNameDB _loziNameDB;

  @override
  void initState() {
    super.initState();
    _loziNameDB = LoziNameDB.instance;
    _loziNameDB.database;
    getData();
  }

  List<LoziDictionary> _foundWords = [];

  String? keyword;

  void _filters(String key) async {
    keyword = key;

    List<LoziDictionary> results = [];

    if (keyword!.isEmpty) {
      getData();
    } else {
      results = await _loziNameDB.searchWords(key);
    }

    setState(() {
      _foundWords = results;
    });
  }

  void getData() async {
    List<LoziDictionary> results = [];
    results = await _loziNameDB.queryAll();
    setState(() {
      _foundWords = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    keyword ??= '';

    for (int i = 0; i < _foundWords.length; i++) {
      _foundWords[i].engMean ??= '';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0.0,
        backgroundColor: Colors.teal,
        title: const Text('Lozi names'),
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
                decoration: const InputDecoration(
                  hintText: 'Type a name here...',
                  labelStyle: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.normal,
                    fontSize: 25,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _foundWords.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 3.5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  _foundWords[index].name.replaceFirst(_foundWords[index].name[0], _foundWords[index].name[0].toUpperCase()),
                                  style: const TextStyle(
                                      fontSize: 20.5,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue),
                                ),
                              ),
                              // _foundWords[index].engMean!.isNotEmpty
                              //     ? const Text(
                              //         'Meaning in english:',
                              //         style: TextStyle(
                              //           fontSize: 17.0,
                              //           color: Colors.blue,
                              //           fontWeight: FontWeight.normal,
                              //         ),
                              //       )
                              //     : const SizedBox(
                              //         height: 0.0,
                              //       ),
                              // _foundWords[index].engMean!.isNotEmpty
                              //     ? Text(
                              //         _foundWords[index].engMean!,
                              //         style: const TextStyle(
                              //           color: Colors.black,
                              //           fontSize: 20.0,
                              //           fontWeight: FontWeight.normal,
                              //         ),
                              //       )
                              //     : const SizedBox(),
                              // _foundWords[index].lozMean!.isNotEmpty
                              //     ? const SizedBox(
                              //         height: 10.0,
                              //       )
                              //     : const SizedBox(),
                              _foundWords[index].lozMean!.isNotEmpty
                                  ? const Text(
                                      'Meaning:',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.5),
                                    )
                                  : const SizedBox(),
                              _foundWords[index].lozMean!.isNotEmpty
                                  ? Text(
                                      _foundWords[index].lozMean!,
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : const SizedBox(),
                              _foundWords[index].origin!.isNotEmpty
                                  ? const SizedBox(
                                      height: 10.0,
                                    )
                                  : const SizedBox(),
                              _foundWords[index].origin!.isNotEmpty
                                  ? const Text(
                                      'Origin:',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.5),
                                    )
                                  : const SizedBox(),
                              _foundWords[index].origin!.isNotEmpty
                                  ? Text(
                                      _foundWords[index].origin!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal),
                                    )
                                  : const SizedBox(),
                            ],
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
