class Favourite {
  final int? id;
  late final String word;
  final bool? ispressed;

  Favourite({
    this.id,
    required this.word,
    this.ispressed
  });

  factory Favourite.fromMap(Map<String, dynamic> json) => Favourite(
    id: json['id'],
    word: json['word'],
    ispressed: json['ispressed'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'ispressed': ispressed,
    };
  }
}