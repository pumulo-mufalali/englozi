class History {
  final int? id;
  late final String word;

  History({
    this.id,
    required this.word
  });

  factory History.fromMap(Map<String, dynamic> json) => History(
      id: json['id'],
      word: json['word'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
    };
  }
}