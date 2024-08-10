import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/models/courseBasicData.dart';
import 'package:mbauser/pages/views/courseDetails.dart';

import 'colors.dart';

class CourseBigThumbnail extends StatelessWidget {

  final CourseBasicData data;

  const CourseBigThumbnail({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
        child: Container(
          height: 180,
          child: Row(
            children: [
              SizedBox(
                height: 180,
                width: 150,
                child: Image.asset(this.data.image, fit: BoxFit.cover,),
              ),
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                      color: MbaColors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///title
                          Row(
                            children: [
                              Text(this.data.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          ///icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 60,
                                child: Column(
                                  children: [
                                    Icon(Icons.play_lesson),
                                    SizedBox(height: 5,),
                                    Text('${this.data.lessons} dərs'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 60,
                                child: Column(
                                  children: [
                                    Icon(FontAwesome.calendar_check_solid),
                                    SizedBox(height: 5,),
                                    Text('${this.data.days} gün'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 60,
                                child: Column(
                                  children: [
                                    Icon(Icons.ballot_outlined),
                                    SizedBox(height: 5,),
                                    Text('${this.data.exams} test'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          ///rating and price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(Icons.star),
                                    SizedBox(width: 5,),
                                    Text(this.data.rating),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(FontAwesome.money_bill_solid, color: Colors.white,),
                                    SizedBox(width: 5,),
                                    Text('₼ ${this.data.price}'),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetails(courseId: data.id)));
      },
    );
  }
}