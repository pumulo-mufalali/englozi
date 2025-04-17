import 'package:englozi/features/drawer.dart';
import 'package:englozi/pages/dictionary_page.dart';
import 'package:englozi/pages/names_page.dart';
import 'package:englozi/pages/phrases_page.dart';
import 'package:englozi/pages/pronounciation_page.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'features/favourite.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _focuses = 1;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const WelcomePage(),
    const FavouritePage(),
    const PronunciationPage(),
  ];

  List<String> cards = ['Phrases', 'Translator', 'Names'];

  void _onItemFocus(int index) {
    setState(() {
      _focuses = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  Widget _buildItemList(BuildContext context, int index) {
    if (_focuses == cards.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Card(
              elevation: 15.0,
              color: Colors.teal,
              child: ClipRRect(
                child: SizedBox(
                  width: 250,
                  height: 400,
                  child: InkWell(
                    child: Center(
                      child: Text(
                        cards[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (cards[_focuses] == cards[0]) {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PhrasesPage()));
                      } else if (cards[index] == cards[1]) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DictionaryPage()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NamesPage()));
                      }
                    },
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            if (_scaffoldkey.currentState?.isDrawerOpen == false) {
              _scaffoldkey.currentState!.openDrawer();
            } else {
              _scaffoldkey.currentState?.openEndDrawer();
            }
          },
          icon: const Icon(Icons.dehaze),
        ),
        title: RichText(
          text: TextSpan(
            text: 'Eng',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'lozi',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Scaffold(
        resizeToAvoidBottomInset: true,
        drawer: const DrawerPage(),
        key: _scaffoldkey,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              ' << Swipe >> ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ScrollSnapList(
                itemBuilder: _buildItemList,
                itemSize: 250,
                initialIndex: 1,
                duration: 100,
                itemCount: cards.length,
                dynamicItemSize: true,
                onItemFocus: _onItemFocus,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
