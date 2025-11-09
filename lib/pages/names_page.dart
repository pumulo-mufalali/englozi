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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    for (int i = 0; i < _foundWords.length; i++) {
      _foundWords[i].engMean ??= '';
    }

    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        elevation: 0.0,
        title: const Row(
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Lozi Names'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _filters(value),
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search a name here...',
                hintStyle: TextStyle(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.primaryColor,
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              _foundWords[index].name.replaceFirst(
                                _foundWords[index].name[0],
                                _foundWords[index].name[0].toUpperCase(),
                              ),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          if (_foundWords[index].lozMean!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 18,
                                  color: theme.primaryColor.withOpacity(0.7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Meaning:',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                _foundWords[index].lozMean!,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                          if (_foundWords[index].origin!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.public_rounded,
                                  size: 18,
                                  color: theme.primaryColor.withOpacity(0.7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Origin:',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                _foundWords[index].origin!,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ],
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
