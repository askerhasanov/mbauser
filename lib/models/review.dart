class Review {
  final String username;
  final String review;
  final double rating;

  Review({
    required this.username,
    required this.review,
    required this.rating,
  });

  factory Review.fromMap(Map<dynamic, dynamic> entry) {
    // Cast entry to Map<String, dynamic> safely
    Map<String, dynamic> data = Map<String, dynamic>.from(entry);

    // Safely handle rating (whether int or string)
    double safeRating;
    if (data['rating'] is int) {
      safeRating = (data['rating'] as int).toDouble();
    } else if (data['rating'] is String) {
      safeRating = double.tryParse(data['rating']) ?? 0.0;
    } else {
      safeRating = 0.0;
    }

    return Review(
      username: data['username'] as String,
      review: data['review'] as String,
      rating: safeRating,
    );
  }
}
