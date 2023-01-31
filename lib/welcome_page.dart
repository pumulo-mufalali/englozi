import 'package:englozi/pages/dictionary_page.dart';
import 'package:englozi/pages/names_page.dart';
import 'package:englozi/pages/phrases_page.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _focuses = 1;
  List<String> cards = ['PHRASES', 'DICTIONARY', 'LOZI NAMES'];

  @override
  void initState() {
    super.initState();
  }

  void _onItemFocus(int index) {
    setState(() {
      _focuses = index;
    });
  }

  Widget _buildItemList(BuildContext context, int index) {
    if (_focuses == cards.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Card(
          elevation: 15.0,
          color: Colors.teal,
          child: ClipRRect(
            child: SizedBox(
              width: 250,
              height: 350,
              child: InkWell(
                child: Center(
                  child: Text(
                    cards[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
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
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              ]),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            InkWell(
              child: UserAccountsDrawerHeader(
                accountName: RichText(
                  text: TextSpan(
                      text: 'Eng',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'lozi',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                ),
                accountEmail: const Text(
                  'Enjoy learning',
                ),
                currentAccountPicture: GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.bookmarks),
                  ),
                ),
              ),
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.bookmark),
                title: Text('Bookmarks'),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.white70,
              height: 15,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.white70,
              height: 15,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.history),
                title: Text('History'),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.white70,
              height: 15,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.ad_units),
                title: Text('About'),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.white70,
              height: 15,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.teal,
                leading: Icon(Icons.help_outline),
                title: Text('Help'),
              ),
              onTap: () {},
            ),
            const Divider(
              color: Colors.white70,
              height: 15,
            ),
            InkWell(
              child: const ListTile(
                iconColor: Colors.black,
                leading: Icon(Icons.cancel),
                title: Text('Exit'),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            ' << Swipe >> ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 25.0,
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
    );
  }
}
