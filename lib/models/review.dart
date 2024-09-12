class Review{
  final String id;
  final String sender;
  final String rating;
  final String text;

  Review({
    required this.id,
    required this.sender,
    required this.rating,
    required this.text,
  });


  factory Review.fromMap(MapEntry<String, dynamic> entry){
    return Review(
        id: entry.key,
        sender: entry.value['username'],
        rating: entry.value['rating'],
        text: entry.value['review']
    );
  }

}