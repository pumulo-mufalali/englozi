class DictionaryModel {
  int id;
  String word;
  String? noun;
  String? plural;
  String? description;
  String? phrase;
  String? verb;
  String t_verb;
  String i_verb;
  String? adjective;
  String? adverb;
  String? preposition;
  String? synonym;
  String? antonym;

  DictionaryModel({
    required this.id,
    required this.word,
    this.noun,
    this.plural,
    this.description,
    this.phrase,
    this.verb,
    required this.t_verb,
    required this.i_verb,
    this.adjective,
    this.adverb,
    this.preposition,
    this.synonym,
    this.antonym,
  });

  factory DictionaryModel.fromMap(Map<String, dynamic> json) => DictionaryModel(
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
      antonym: json['antonym']
  );

}
