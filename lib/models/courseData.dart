import 'package:firebase_database/firebase_database.dart';
import 'package:mbauser/models/review.dart';

class CourseData {
  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final String price;
  final List<String> lessons; // Lessons as List<String>
  final String about;
  final List<Review> reviews;
  final String category;
  final double rating;

  CourseData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.videoUrl,
    required this.price,
    required this.lessons,
    required this.about,
    required this.reviews,
    required this.category,
    required this.rating,
  });

  // Calculate the average rating based on the reviews
  static double _calculateRating(Map<dynamic, dynamic> reviewsMap) {
    if (reviewsMap.isEmpty) return 0.0;
    double totalRating = 0.0;
    reviewsMap.forEach((key, value) {
      if (value is Map && value.containsKey('rating')) {
        totalRating += value['rating'] is int ? (value['rating'] as int).toDouble() : double.tryParse(value['rating'].toString()) ?? 0.0;
      }
    });
    return totalRating / reviewsMap.length;
  }

  factory CourseData.fromSnapshot(DataSnapshot snapshot) {
    // Handle lessons safely, making sure it's a list of strings
    List<String> lessonsList = [];
    if (snapshot.child('lessons').value is List) {
      lessonsList = List<String>.from(
        (snapshot.child('lessons').value as List).where((lesson) => lesson != null).map((lesson) => lesson.toString()),
      );
    }

    // Handle reviews as a Map and cast it safely
    Map<dynamic, dynamic> reviewsMap = snapshot.child('reviews').value != null
        ? Map<dynamic, dynamic>.from(snapshot.child('reviews').value as Map)
        : {};

    return CourseData(
      id: snapshot.key!,
      name: snapshot.child('name').value as String,
      imageUrl: snapshot.child('imageUrl').value as String,
      videoUrl: snapshot.child('videoUrl').value as String,
      price: snapshot.child('price').value.toString(),
      lessons: lessonsList, // Safely cast lessons list
      about: snapshot.child('about').value as String,
      reviews: reviewsMap.entries.map((entry) => Review.fromMap(Map<String, dynamic>.from(entry.value as Map))).toList(), // Updated review parsing
      category: snapshot.child('category').value as String,
      rating: _calculateRating(reviewsMap), // Calculate rating
    );
  }
}
