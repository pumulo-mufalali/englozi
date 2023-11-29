class LoziDictionary {
  int id;
  String name;
  String? engMean;
  String? lozMean;
  String? origin;

  LoziDictionary({
    required this.id,
    required this.name,
    this.engMean,
    this.lozMean,
    this.origin
  });

  factory LoziDictionary.fromMap(Map<String, dynamic> json) => LoziDictionary(
    id: json['id'],
    name: json['name'],
    engMean: json['engMean'],
    lozMean: json['lozMean'],
    origin: json['origin'],
  );
}