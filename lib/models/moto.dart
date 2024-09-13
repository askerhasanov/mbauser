class Moto {
  final String title;
  final String about;
  final List<String> images;
  final String maker;
  final String model;
  final String engine;
  final String price;
  final String trip;
  final String year;
  final DateTime dateAdded;

  // Constructor
  Moto({
    required this.title,
    required this.about,
    required this.images,
    required this.maker,
    required this.model,
    required this.engine,
    required this.price,
    required this.trip,
    required this.year,
    required this.dateAdded,
  });

  factory Moto.fromMap(Map<dynamic, dynamic> map) {
    return Moto(
      title: '${map['maker']} ${map['model']} ${map['engine']}cc',
      about: map['about'],
      images: List<String>.from(map['images']),
      maker: map['maker'],
      model: map['model'],
      engine: map['engine'],
      price: map['price'],
      trip: map['trip'],
      year: map['year'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'about': about,
      'images': images,
      'maker': maker,
      'model': model,
      'engine': engine,
      'price': price,
      'trip': trip,
      'year': year,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }
}
