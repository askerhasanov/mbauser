import 'package:flutter/material.dart';
import '../../elements/courseBigThumbnail.dart';
import '../../elements/pageheader.dart';
import '../../models/courseBasicData.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {

  final List<CourseBasicData> _coursesList = [
    CourseBasicData(id: 'dassdada', name: 'Sadə Paket', image: 'images/1.jpeg', price: '300', rating: '4.5', lessons: '8', days: '8', exams: '2'),
    CourseBasicData(id: 'dassdadb', name: 'Orta Paket', image: 'images/2.jpeg', price: '500', rating: '4.5', lessons: '12', days: '12', exams: '3'),
    CourseBasicData(id: 'dassdadc', name: 'Premium Paket', image: 'images/3.jpeg', price: '1000', rating: '4.5', lessons: '18', days: '18', exams: '5'),
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
            child: Column(
                children: [
                  ///header
                  const pageHeader(text: 'Kurslar'),
                  ListView.builder(
                      itemCount: _coursesList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return CourseBigThumbnail(data: _coursesList[index],);
                      }
                  )
                ]
            )
        )
    );
  }
}




