import 'package:englozi/databases/translator_db.dart';
import 'package:englozi/databases/favourite_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/tra_model.dart';
import 'package:englozi/model/fav_model.dart';
import 'package:englozi/pages/pronounciation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../features/bottom_navbar.dart';
import '../features/favourite.dart';

class WordDetails extends StatefulWidget {
  String word;
  String? noun;
  String? plural;
  String? description;
  String? phrase;
  String? verb;
  String? t_verb;
  String? i_verb;
  String? adjective;
  String? adverb;
  String? preposition;
  String? synonym;
  String? antonym;
  String? conjunction;

  WordDetails(
      {super.key,
      required this.word,
      this.noun,
      this.plural,
      this.description,
      this.phrase,
      this.verb,
      this.t_verb,
      this.i_verb,
      this.adjective,
      this.adverb,
      this.preposition,
      this.synonym,
      this.antonym,
      this.conjunction});

  @override
  State<WordDetails> createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  bool _isFavourited = false;
  late DatabaseFavourite dbFavourite = DatabaseFavourite.instance;

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FavouritePage(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PronunciationPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();

    dbHelper = DatabaseHelper.instance;
    dbHelper.database;

    dbFavourite = DatabaseFavourite.instance;
    dbFavourite.database;
    getData();
  }

  Widget _buildClickableWordList(
      String? content, String title, BuildContext context) {
    if (content == null || content.isEmpty) return const SizedBox();

    final words = content.split(',').map((word) => word.trim()).toList();

    return Center(
      child: FutureBuilder<Map<String, bool>>(
        future: dbHelper.checkWordsExist(words),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return _buildSectionTitle(title);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(title),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: SizedBox(
                  height: 24,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: words.length,
                    separatorBuilder: (_, __) => const Text(", "),
                    itemBuilder: (context, index) {
                      final word = words[index];
                      final exists = snapshot.data![word] ?? false;
                      return GestureDetector(
                        onTap: exists
                            ? () => _navigateToWord(word, context)
                            : null,
                        child: Text(
                          word,
                          style: TextStyle(
                            color: exists ? Colors.blue : Colors.black,
                            decoration: exists ? TextDecoration.none : null,
                            fontSize: 15.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontSize: 16.5,
        ),
      ),
    );
  }

  void _navigateToWord(String word, BuildContext context) async {
    final cleanWord = word.replaceAll(RegExp(r'[^\w- ]'), '');

    if (cleanWord.isEmpty) return;

    try {
      final results = await dbHelper.searchWords(cleanWord);
      if (results.isNotEmpty && mounted) {
        final result = results.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordDetails(
              word: result.word,
              noun: result.noun,
              plural: result.plural,
              description: result.description,
              phrase: result.phrase,
              verb: result.verb,
              t_verb: result.t_verb,
              i_verb: result.i_verb,
              adjective: result.adjective,
              adverb: result.adverb,
              preposition: result.preposition,
              synonym: result.synonym,
              antonym: result.antonym,
              conjunction: result.conjunction,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"$cleanWord" not found in dictionary')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error looking up word')),
        );
      }
    }
  }

  TextSpan _buildStyledText(String text) {
    final regex = RegExp(r'(\(.*?\))');
    final matches = regex.allMatches(text);
    final List<TextSpan> spans = [];
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15.5,
            ),
          ),
        );
      }

      final fullMatch = match.group(0)!;
      spans.addAll([
        const TextSpan(
          text: '(',
          style: TextStyle(color: Colors.white),
        ),
        TextSpan(
          text: fullMatch.substring(1, fullMatch.length - 1),
          style: const TextStyle(
            color: Colors.blue,
            fontStyle: FontStyle.normal,
            fontSize: 15.5,
          ),
        ),
        const TextSpan(
          text: ')',
          style: TextStyle(color: Colors.white),
        ),
      ]);

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: const TextStyle(color: Colors.black),
      ));
    }

    return TextSpan(children: spans);
  }

  Future<void> _checkFavoriteStatus() async {
    _isFavourited = await dbFavourite.isWordFavourited(widget.word);
    if (mounted) setState(() {});
  }

  Future<void> _toggleFavourite() async {
    if (_isFavourited) {
      await dbFavourite.deleteFavouriteByWord(widget.word);
    } else {
      await dbFavourite.insertFavourite(
        Favourite(word: widget.word, isPressed: true),
      );
    }
    setState(() => _isFavourited = !_isFavourited);
  }

  late DatabaseHelper dbHelper;

  final FlutterTts flutterTts = FlutterTts();
  late List<TranslatorModel> words;
  List<Favourite> wordz = [];

  bool? isPressed;

  void getData() async {
    List<Favourite> result = await dbFavourite.getAllFavourites();
    setState(() {
      wordz = result;
    });
  }

  void initData(String key) async {
    words = await dbHelper.searchWords(key);
  }

  List<Favourite> result = [];

  void getAllFav() async {
    List<Favourite> results = [];
    if (result.isEmpty) {
      results = [];
    } else {
      results = await dbFavourite.getAllFavourites();
    }
    setState(() {
      result = results;
    });
  }

  speak(String text) async {
    await flutterTts.setPitch(0.1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("en");
    await flutterTts.setSpeechRate(0.4);
    return await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    widget.noun ??= '';
    widget.plural ??= '';
    widget.description ??= '';
    widget.phrase ??= '';
    widget.verb ??= '';
    widget.t_verb ??= '';
    widget.i_verb ??= '';
    widget.adjective ??= '';
    widget.adverb ??= '';
    widget.preposition ??= '';
    widget.synonym ??= '';
    widget.antonym ??= '';
    widget.conjunction ??= '';

    isPressed ??= false;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Text(
          widget.word,
        ),
        actions: [
          IconButton(
            onPressed: () => {speak(widget.word)},
            icon: const Icon(Icons.volume_up),
          ),
          Container(
            height: 20,
            width: 2,
            color: Colors.white.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          IconButton(
            onPressed: () => {
              _toggleFavourite(),
            },
            icon: Icon(_isFavourited ? Icons.favorite : Icons.favorite_border),
          ),
        ],
        centerTitle: false,
        automaticallyImplyLeading: true,
        elevation: 0.0,
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerPage(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              widget.description!.isNotEmpty
                  ? const Divider(
                      height: 0.0,
                      color: Colors.grey,
                      thickness: 1.5,
                      endIndent: 15.0,
                      indent: 15.0,
                    )
                  : const SizedBox(
                      height: 0.0,
                    ),
              widget.description!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: ListTile(
                        title: widget.description!.isNotEmpty
                            ? RichText(
                                text: TextSpan(
                                  text: widget.description![0].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 15.5,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic),
                                  children: [
                                    TextSpan(
                                      text: widget.description!.substring(
                                          1, widget.description!.length),
                                      style: const TextStyle(
                                          fontSize: 15.5,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(
                                height: 0.0,
                              ),
                      ),
                    )
                  : const SizedBox(),
              Column(
                children: [
                  widget.noun!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.noun!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Noun',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.noun!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.plural!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.plural!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Plural',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.plural!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.verb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.verb!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Verb',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.verb!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.t_verb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.t_verb!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Transitive verb',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.t_verb!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.i_verb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.i_verb!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Intransitive verb',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.i_verb!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.phrase!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.phrase!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Phrase',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.phrase!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.adjective!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.adjective!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Adjective',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.adjective!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.adverb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.adverb!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Adverb',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.adverb!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.conjunction!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.conjunction!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Conjunction',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.conjunction!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.preposition!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.preposition!.isNotEmpty)
                    ListTile(
                      title: const Text(
                        'Preposition',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                      subtitle: RichText(
                        text: _buildStyledText(widget.preposition!),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.synonym!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.synonym?.isNotEmpty ?? false)
                    _buildClickableWordList(widget.synonym, "Synonym", context),
                  widget.antonym!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 1.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.antonym?.isNotEmpty ?? false)
                    _buildClickableWordList(widget.antonym, "Antonym", context),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
