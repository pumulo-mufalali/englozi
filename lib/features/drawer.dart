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
import 'package:englozi/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        elevation: 0.0,
        backgroundColor: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          theme.primaryColor.withOpacity(0.3),
                          theme.primaryColor.withOpacity(0.1),
                        ]
                      : [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.7),
                        ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Eng',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'lozi',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFFF87171)
                                  : const Color(0xFFEF4444),
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dictionary & Translator',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.volume_up_rounded,
              title: 'Pronunciation',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PronunciationPage(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.shuffle_rounded,
              title: 'Random word',
              onTap: () {
                Navigator.pop(context);
                randomSearch();
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.favorite_outline_rounded,
              title: 'Favourites',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouritePage(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.history_rounded,
              title: 'History',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: theme.primaryColor,
              ),
              title: Text(
                themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                style: theme.textTheme.bodyLarge,
              ),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
                activeColor: theme.primaryColor,
              ),
            ),
            const Divider(height: 1),
            _buildDrawerItem(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Help',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info_outline_rounded,
              title: 'About',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              context,
              icon: Icons.exit_to_app_rounded,
              title: 'Exit',
              isDestructive: true,
              onTap: () {
                exit(0);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? (isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444))
            : theme.primaryColor,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? (isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444))
              : null,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
