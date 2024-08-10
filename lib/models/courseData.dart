class CourseData {

  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final String price;
  final List<String> lessons;
  final String about;
  final List<String> reviews;

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
}
