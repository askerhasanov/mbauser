import 'package:intl/intl.dart';

class Event {
  final String title;
  final String about;
  final String date;
  final DateTime dateAdded;
  final bool forMembers;
  final bool isPayed;
  final String price;
  final String image; // additional field specific to Event

  Event({
    required this.title,
    required this.about,
    required this.date,
    required this.dateAdded,
    required this.forMembers,
    required this.isPayed,
    required this.price,
    required this.image
  });

  factory Event.fromMap(Map<dynamic, dynamic> data) {

    final dateString = data['dateAdded'] ?? '';
    final DateTime parsedDate = DateFormat('dd-MM-yyyy HH:mm:ss').parse(dateString);

    return Event(
      title: data['title'] ?? 'No Title',
      about: data['about'] ?? 'No Description',
      date: data['date'] ?? 'No Location',
      dateAdded: parsedDate,
      forMembers: data['isForMembers'],
      isPayed: data['isPayed'],
      price: data['price'] ?? '',
      image: data['imageUrl'] ?? 'no image',
    );
  }
}