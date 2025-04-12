class Favourite {
  final int? id;
  final String word;
  final bool isPressed;

  Favourite({
    this.id,
    required this.word,
    this.isPressed = false,
  });

  factory Favourite.fromMap(Map<String, dynamic> map) {
    return Favourite(
      id: map['id'],
      word: map['word'],
      isPressed: map['isPressed'] == 1, // Convert 1/0 to bool
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'isPressed': isPressed ? 1 : 0, // Convert bool to 1/0
    };
  }
}