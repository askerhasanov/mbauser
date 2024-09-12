import 'package:intl/intl.dart';

class News {
  final String title;
  final String image;
  final String text;
  final DateTime date; // additional field specific to News

  News({required this.title, required this.image, required this.text, required this.date});

  factory News.fromMap(Map<dynamic, dynamic> data) {

    final dateString = data['dateAdded'] ?? '';
    final DateTime parsedDate = DateFormat('dd-MM-yyyy HH:mm:ss').parse(dateString);

    return News(
      title: data['title'] ?? 'No Title',
      image: data['imageUrl'] ?? 'No Title',
      text: data['text'] ?? 'No Content',
      date: parsedDate,
    );
  }
}