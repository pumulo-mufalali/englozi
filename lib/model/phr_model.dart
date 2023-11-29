class PhraseDictionary {
  int? id;
  String phrSilozi;
  String phrEnglish;

  PhraseDictionary({
    this.id,
    required this.phrEnglish,
    required this.phrSilozi,
  });

  factory PhraseDictionary.fromMap(Map<String, dynamic> json) => PhraseDictionary(
    id: json['id'],
    phrEnglish: json['phrEnglish'],
    phrSilozi: json['phrSilozi'],
  );
}