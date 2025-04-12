import 'package:englozi/databases/dictionary_db.dart';
import 'package:englozi/databases/favourite_db.dart';
import 'package:englozi/features/drawer.dart';
import 'package:englozi/model/dic_model.dart';
import 'package:englozi/model/fav_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  late List<DictionaryModel> words;
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

  void speak(String text) async {
    await flutterTts.setPitch(0.1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
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
        title: RichText(
          text: TextSpan(
            text: widget.word[0].toUpperCase(), // WORD
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.5,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: widget.word.substring(1, widget.word.length),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {speak(widget.word)},
            icon: const Icon(Icons.volume_up),
          ),
          Container(
            height: 20,  // Matches IconButton height
            width: 2,
            color: Colors.white.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          IconButton(
            onPressed: () => {_toggleFavourite(),},
            icon: Icon(_isFavourited ? Icons.favorite : Icons.favorite_border),
            color: Colors.redAccent,
          ),
        ],
        centerTitle: false,
        automaticallyImplyLeading: true,
        elevation: 0.0,
      ),
      body: Scaffold(
        drawer: const DrawerPage(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 12.0,
              ),
              widget.description!.isNotEmpty
                  ? const SizedBox(
                      height: 10.0,
                    )
                  : const SizedBox(),
              widget.description!.isNotEmpty
                  ? const Divider(
                      height: 0.0,
                      color: Colors.grey,
                      thickness: 2.5,
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
                        title: widget.description!.isNotEmpty //DESCRIPTION
                            ? RichText(
                                text: TextSpan(
                                  text: widget.description![0].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic),
                                  children: [
                                    TextSpan(
                                      text: widget.description!.substring(
                                          1, widget.description!.length),
                                      style: const TextStyle(
                                          fontSize: 20.0,
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
              widget.description!.isNotEmpty
                  ? const SizedBox(
                      height: 5.0,
                    )
                  : const SizedBox(height: 10.0),
              Column(
                children: [
                  widget.noun!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.noun!.isNotEmpty) // NOUN
                    ListTile(
                      title: const Text(
                        'Noun \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.noun!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.plural!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.plural!.isNotEmpty) // PLURAL
                    ListTile(
                      title: const Text(
                        'Plural noun(s) \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.plural!,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.verb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.verb!.isNotEmpty) // TRANSITIVE VERB
                    ListTile(
                      title: const Text(
                        'Verb \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.verb!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.t_verb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.t_verb!.isNotEmpty) // TRANSITIVE VERB
                    ListTile(
                      title: const Text(
                        'Transitive verb \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.t_verb!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.i_verb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.i_verb!.isNotEmpty) // INTRANSITIVE VERB
                    ListTile(
                      title: const Text(
                        'Intransitive verb \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.i_verb!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.phrase!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.phrase!.isNotEmpty) // PHRASE
                    ListTile(
                      title: const Text(
                        'Phrase \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.phrase!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.adjective!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.adjective!.isNotEmpty) // ADJECTIVE
                    ListTile(
                      title: const Text(
                        'Adjective \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.adjective!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.adverb!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.adverb!.isNotEmpty) // ADVERB
                    ListTile(
                      title: const Text(
                        'Adverb \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.adverb!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.conjunction!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.conjunction!.isNotEmpty) // PREPOSITION
                    ListTile(
                      title: const Text(
                        'Conjunction \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.conjunction!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.preposition!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.preposition!.isNotEmpty) // PREPOSITION
                    ListTile(
                      title: const Text(
                        'Preposition \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        widget.preposition!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.synonym!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.synonym!.isNotEmpty) // SYNONYM
                    ListTile(
                      title: const Text(
                        'Synonym \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: SelectableText(
                        widget.synonym!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  widget.antonym!.isNotEmpty
                      ? const Divider(
                          height: 0.0,
                          color: Colors.grey,
                          thickness: 2.5,
                          endIndent: 15.0,
                          indent: 15.0,
                        )
                      : const SizedBox(),
                  if (widget.antonym!.isNotEmpty) // ANTONYM
                    ListTile(
                      title: const Text(
                        'Antonym \n',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: SelectableText(
                        widget.antonym!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
