import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mbauser/elements/courseCardWidget.dart';
import 'package:provider/provider.dart';
import '../../models/courseCard.dart';
import '../../providers/mbaProvider.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  List<CourseCardModel> activeCourses = [];
  List<CourseCardModel> endedCourses = [];
  StreamSubscription? _courseSubscription;

  @override
  void initState() {
    super.initState();
    _listenForCourses();
  }

  void _listenForCourses() {
    final userId = Provider.of<MBAProvider>(context, listen: false).userId;
    _courseSubscription = FirebaseDatabase.instance
        .ref()
        .child('users/$userId/myCourses')
        .onValue
        .listen((event) {
      if (mounted) {
        final data = event.snapshot.value as Map?;
        setState(() {
          if (data != null) {
            activeCourses = [];
            endedCourses = [];
            data.forEach((key, value) {
              final course = CourseCardModel.fromMap(Map<String, dynamic>.from(value));
              if (course.status == 'active') {
                activeCourses.add(course);
              } else {
                endedCourses.add(course);
              }
            });
          } else {
            activeCourses = [];
            endedCourses = [];
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _courseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Kurslarım', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            if (activeCourses.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Aktiv Kurslar', style: TextStyle(fontSize: 18, color: Colors.red)),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: activeCourses.length,
                itemBuilder: (context, index) {
                  final course = activeCourses[index];
                  return CourseCardWidget(course: course);
                },
              ),
            ),
            if (endedCourses.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Bitmiş Kurslar', style: TextStyle(fontSize: 18, color: Colors.red)),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: endedCourses.length,
                itemBuilder: (context, index) {
                  final course = endedCourses[index];
                  return CourseCardWidget(course: course);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
