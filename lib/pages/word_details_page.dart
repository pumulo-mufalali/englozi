import 'package:flutter/material.dart';

class WordDetails extends StatefulWidget {
  String word;
  String? noun;
  String? plural;
  String? description;
  String? phrase;
  String? verb;
  bool? t_verb;
  bool? i_verb;
  String? adjective;
  String? adverb;
  String? preposition;
  String? synonym;
  String? antonym;

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
        this.antonym});

  @override
  State<WordDetails> createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Dictionary',
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(children: [
              InkWell(
                child: const Icon(
                  Icons.volume_up,
                ),
                onTap: () {},
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(widget.word,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                  )),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.all(9.0),
              child: Card(
                color: Colors.teal,
                child: ListTile(
                  title: RichText(
                      text: TextSpan(
                          text: widget.word,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: widget.description!.isNotEmpty
                                    ? '  [${widget.description}]'
                                    : '',
                                style: const TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic))
                          ])),
                  subtitle: Text(
                    widget.noun!.isNotEmpty ? widget.noun! : widget.verb!,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}