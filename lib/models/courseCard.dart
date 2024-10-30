class CourseCardModel {
  final String courseId;
  final String courseName;
  final String enrollmentDate;
  final String status;
  final Map<String, dynamic> payment; // Change this to Map<String, dynamic>
  final String branch;

  CourseCardModel({
    required this.courseId,
    required this.courseName,
    required this.enrollmentDate,
    required this.status,
    required this.payment,
    required this.branch,
  });

  // Factory method to create a CourseCardModel from Firebase data
  factory CourseCardModel.fromMap(Map<String, dynamic> data) {
    return CourseCardModel(
      courseId: data['courseId'] ?? '',
      courseName: data['courseName'] ?? '',
      enrollmentDate: data['enrollmentDate'] ?? '',
      status: data['status'] ?? '',
      payment: Map<String, dynamic>.from(data['payment'] ?? {}), // Convert payment to Map<String, dynamic>
      branch: data['branch'] ?? '',
    );
  }
}
