import 'package:englozi/features/drawer.dart';
import 'package:englozi/pages/translator_page.dart';
import 'package:englozi/pages/names_page.dart';
import 'package:englozi/pages/phrases_page.dart';
import 'package:englozi/pages/pronounciation_page.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:englozi/features/favourite.dart';

// import 'features/bottom_navbar.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _focuses = 1;
  int _currentIndex = 0;

  List<String> cards = ['Phrases', 'Translator', 'Names'];

  void _onItemFocus(int index) {
    setState(() {
      _focuses = index;
    });
  }

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

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  Widget _buildItemList(BuildContext context, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (_focuses == cards.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final isFocused = _focuses == index;
      final cardColors = [
        [const Color(0xFF14B8A6), Colors.teal],
        [const Color(0xFF14B8A6), Colors.teal],
        [const Color(0xFF14B8A6), Colors.teal],
      ];
      
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isFocused ? 280 : 250,
              height: isFocused ? 420 : 400,
              child: Card(
                elevation: isFocused ? 20.0 : 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              cardColors[index][0].withOpacity(0.8),
                              cardColors[index][1].withOpacity(0.6),
                            ]
                          : cardColors[index],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cardColors[index][0].withOpacity(0.3),
                        blurRadius: isFocused ? 30 : 15,
                        spreadRadius: isFocused ? 5 : 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () async {
                        if (cards[_focuses] == cards[0]) {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PhrasesPage()));
                        } else if (cards[index] == cards[1]) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TranslatorPage()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NamesPage()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              index == 0
                                  ? Icons.chat_bubble_outline
                                  : index == 1
                                      ? Icons.translate
                                      : Icons.person_outline,
                              size: isFocused ? 80 : 70,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              cards[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isFocused ? 38.0 : 35.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              if (_scaffoldkey.currentState?.isDrawerOpen == false) {
                _scaffoldkey.currentState!.openDrawer();
              } else {
                _scaffoldkey.currentState?.openEndDrawer();
              }
            },
            icon: const Icon(Icons.menu_rounded),
          ),
          title: RichText(
            text: TextSpan(
              text: 'Eng',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              children: [
                TextSpan(
                  text: 'lozi',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFF87171)
                        : const Color(0xFFEF4444),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: const DrawerPage(),
        key: _scaffoldkey,
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.scaffoldBackgroundColor,
                      theme.scaffoldBackgroundColor.withOpacity(0.95),
                    ],
                  ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.cardColor.withOpacity(0.5)
                      : theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swipe_rounded,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Swipe to explore',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ScrollSnapList(
                  itemBuilder: _buildItemList,
                  itemSize: 250,
                  initialIndex: 1,
                  duration: 200,
                  itemCount: cards.length,
                  dynamicItemSize: true,
                  onItemFocus: _onItemFocus,
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
    );
  }
}