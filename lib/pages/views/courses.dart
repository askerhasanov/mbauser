import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../models/courseData.dart';
import '../../elements/courseBigThumbnail.dart';
import '../../elements/pageheader.dart';
import '../../elements/colors.dart';
import 'courseDetails.dart';
import 'joinCoursePage.dart'; // Assuming this contains your color definitions

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final List<CourseData> _ecoCourses = [];
  final List<CourseData> _premiumCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final DatabaseReference coursesRef = FirebaseDatabase.instance.ref('courses');
    DataSnapshot snapshot = await coursesRef.get();

    if (snapshot.exists) {
      print("Courses data found: ${snapshot.value}"); // Debugging line to check data

      Map<String, dynamic> coursesData = Map<String, dynamic>.from(snapshot.value as Map);

      // Iterate through the courses
      for (var entry in coursesData.entries) {
        DataSnapshot courseSnapshot = snapshot.child(entry.key); // Use DataSnapshot

        // Create CourseData from snapshot
        CourseData course = CourseData.fromSnapshot(courseSnapshot);
        print("Loaded course: ${course.name} - Category: ${course.category}"); // Debugging line

        // Sort courses into eco or premium
        if (course.category == 'eco') {
          _ecoCourses.add(course);
          print("Added to Eco courses: ${course.name}"); // Debugging line
        } else if (course.category == 'vip') {
          _premiumCourses.add(course);
          print("Added to Premium courses: ${course.name}"); // Debugging line
        }
      }

      setState(() {
        isLoading = false;
        print("Data loading complete, updating UI."); // Debugging line
      });
    } else {
      print("No courses data found."); // Debugging line if no data found
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs for Eco and Premium
      child: Scaffold(
        backgroundColor: MbaColors.lightBg, // Assuming this is your background color
        body: Column(
          children: [
            const pageHeader(text: 'Kurslar'), // Keeping your original header

            // Custom Tab Buttons Below Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: MbaColors.lightRed3, // Use your custom color for background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: MbaColors.white, // Use your custom color for selected tab
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorPadding: EdgeInsets.all(2),
                  dividerColor: Colors.transparent,
                  labelColor: MbaColors.red,
                  unselectedLabelColor: MbaColors.dark, // Unselected text color
                  tabs: const [
                    Tab(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.discount_shape_bold, size: 20,),
                        SizedBox(width: 10,),
                        Text('ECO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                      ],
                    ),),
                    Tab(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesome.crown_solid, size: 20,),
                        SizedBox(width: 10,),
                        Text('VIP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                      ],
                    ),),
                  ],
                ),
              ),
            ),

            // Course List or Loading Indicator
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                children: [
                  _buildCourseList(_ecoCourses),
                  _buildCourseList(_premiumCourses),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Inside _buildCourseList in CoursesPage
  Widget _buildCourseList(List<CourseData> courses) {
    if (courses.isEmpty) {
      return const Center(child: Text('No courses available'));
    }
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigate to JoinCoursePage with the course data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetails(course: courses[index]), // Pass course data here
              ),
            );
          },
          child: CourseBigThumbnail(data: courses[index]),
        );
      },
    );
  }

}
