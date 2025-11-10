import 'package:englozi/databases/phrases_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/phr_model.dart';
import 'package:englozi/pages/phrases_details_page.dart';
import 'package:flutter/material.dart';
import 'package:englozi/features/help/englozi_switch.dart';

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
  }

  List<PhraseDictionary> _foundWords = [];

  String? keyword;

  void _filters(String key) async {
    keyword = key.isEmpty ? null : key;
    List<PhraseDictionary> results = [];
    if (keyword != null && keyword!.isNotEmpty) {
      results = await _phrasesDB.searchWords(key);
    }
    setState(() {
      _foundWords = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Phrases"),
        actions: [
          IconButton(
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
            tooltip: 'Help',
          ),
        ],
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
                                  _foundWords[index].phrEnglish[0].toUpperCase() +
                                      _foundWords[index].phrEnglish.substring(1),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                subtitle: const SizedBox(height: 4),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: theme.primaryColor.withOpacity(0.6),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PhrasesDetailsPage(
                                        phrase: _foundWords[index],
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
                                'Phrase not found',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try searching for a different phrase',
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
                            'Enter a phrase to view details',
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
