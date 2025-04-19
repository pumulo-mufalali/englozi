class TranslatorModel {
  int id;
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

  TranslatorModel({
    required this.id,
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
    this.conjunction
  });

  factory TranslatorModel.fromMap(Map<String, dynamic> json) => TranslatorModel(
    id: json['id'],
    word: json['word'],
    noun: json['noun'],
    plural: json['plural'],
    description: json['description'],
    phrase: json['phrase'],
    verb: json['verb'],
    t_verb: json['t_verb'],
    i_verb: json['i_verb'],
    adjective: json['adjective'],
    adverb: json['adverb'],
    preposition: json['preposition'],
    synonym: json['synonym'],
    antonym: json['antonym'],
    conjunction: json['conjunction'],
  );

}
