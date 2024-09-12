import 'package:firebase_database/firebase_database.dart';
import 'package:mbauser/models/review.dart';

class CourseData {
  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final String price;
  final List<Map<dynamic,dynamic>> lessons;
  final String about;
  final List<Review> reviews;

  CourseData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.videoUrl,
    required this.price,
    required this.lessons,
    required this.about,
    required this.reviews,
  });

  factory CourseData.fromSnapshot(DataSnapshot snapshot) {
    return CourseData(
        id: snapshot.key!,
        name: snapshot.child('name').value as String,
        imageUrl: snapshot.child('imageUrl').value as String,
        videoUrl: snapshot.child('videoUrl').value as String,
        price: snapshot.child('price').value as String,
        lessons: (snapshot.child('lessons').value as Map<dynamic, dynamic>).entries.map((entry) => {entry.key: entry.value}).toList(),
        about: snapshot.child('about').value as String,
        reviews: (snapshot.child('lessons').value as Map<String, dynamic>).entries.map((entry) => Review.fromMap(entry) ).toList(),
    );
  }

}
