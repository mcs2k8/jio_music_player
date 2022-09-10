class Artist {
  final String id;
  final String type;
  final String typeId;
  final int score;
  final String name;
  final String sortName;
  final String? country;
  late final String? image;

  Artist({required this.id, required this.type, required this.typeId, required this.score, required this.name, required this.sortName,
    required this.country, this.image});

  factory Artist.fromJson(Map<String,dynamic> json){
    return Artist(id: json['id'], type: json['type'], typeId: json['type-id'], score: json['score'], name: json['name'], sortName: json['sort-name'], country: json['country']);
  }

  void addImage(String image){
    this.image = image;
  }
}