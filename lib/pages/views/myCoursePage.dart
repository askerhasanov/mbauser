import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../elements/courseCardWidget.dart';
import '../../globalVariables.dart';
import '../../models/coursecard.dart';


class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  List<CourseCardModel> courses = [];
  StreamSubscription? _courseSubscription; // To handle Firebase listener subscription

  @override
  void initState() {
    super.initState();
    _listenForCourses(); // Start listening for Firebase changes
  }

  // Function to listen for course updates in Firebase
  void _listenForCourses() {
    _courseSubscription = FirebaseDatabase.instance
        .ref()
        .child('users/$CurrentUserID/myCourses')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map?;
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          if (data != null) {
            courses = data.values
                .map((course) => CourseCardModel.fromMap(Map<String, dynamic>.from(course)))
                .toList();
          } else {
            courses = [];
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _courseSubscription?.cancel(); // Cancel Firebase listener when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              'Kursum',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: courses.isEmpty
                  ? const Center(child: Text('Kursunuz yoxdur'))
                  : ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseCardWidget(
                    course: course,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
