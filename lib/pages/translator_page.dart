import 'package:englozi/databases/translator_db.dart';
import 'package:englozi/databases/history_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/tra_model.dart';
import 'package:englozi/model/his_model.dart';
import 'package:englozi/pages/pronounciation_page.dart';
import 'package:englozi/pages/word_details_page.dart';
import 'package:englozi/welcome_page.dart';
import 'package:flutter/material.dart';

// import '../features/bottom_navbar.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const DrawerPage(),
      appBar: AppBar(
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
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.translate_rounded,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Translator'),
          ],
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (value) async {
                if (keyword!.isNotEmpty && _foundWords.isNotEmpty) {
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
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search for a word...',
                hintStyle: TextStyle(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.primaryColor,
                ),
                suffixIcon: keyword!.isNotEmpty && _foundWords.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: theme.primaryColor,
                        ),
                        onPressed: () async {
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
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _foundWords.isNotEmpty
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
                              _foundWords[index].word,
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
                                    adjective: _foundWords[index].adjective,
                                    adverb: _foundWords[index].adverb,
                                    preposition: _foundWords[index].preposition,
                                    synonym: _foundWords[index].synonym,
                                    antonym: _foundWords[index].antonym,
                                    conjunction: _foundWords[index].conjunction,
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
                    )
                  : keyword!.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Word not found',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try searching for a different word',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
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
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enter a word to translate',
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
