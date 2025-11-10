import 'package:englozi/databases/loziname_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/loz_model.dart';
import 'package:englozi/pages/names_details_page.dart';
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
  }

  List<LoziDictionary> _foundWords = [];

  String? keyword;

  void _filters(String key) async {
    keyword = key.isEmpty ? null : key;

    List<LoziDictionary> results = [];

    if (keyword != null && keyword!.isNotEmpty) {
      results = await _loziNameDB.searchWords(key);
    }

    setState(() {
      _foundWords = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    for (int i = 0; i < _foundWords.length; i++) {
      _foundWords[i].engMean ??= '';
    }

    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Lozi Names"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              textInputAction: TextInputAction.search,
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
            const SizedBox(height: 20),
            Expanded(
              child: keyword != null && keyword!.isNotEmpty
                  ? (_foundWords.isNotEmpty
                      ? ListView.builder(
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
                                  vertical: 12,
                                ),
                                title: Text(
                                  _foundWords[index].name.replaceFirst(
                                    _foundWords[index].name[0],
                                    _foundWords[index].name[0].toUpperCase(),
                                  ),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: theme.primaryColor.withOpacity(0.6),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NamesDetailsPage(
                                        name: _foundWords[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: theme.colorScheme.onSurface.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Name not found',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try searching for a different name',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ))
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 64,
                            color: theme.primaryColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Start searching',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter a name to view details',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
