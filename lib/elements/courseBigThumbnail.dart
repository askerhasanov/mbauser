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
        child: SizedBox(
          height: 180,
          child: Row(
            children: [
              SizedBox(
                height: 180,
                width: 150,
                child: Image.asset(data.image, fit: BoxFit.cover,),
              ),
              Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
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
                              Text(data.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          ///icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 60,
                                child: Column(
                                  children: [
                                    const Icon(Icons.play_lesson),
                                    const SizedBox(height: 5,),
                                    Text('${data.lessons} dərs'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 60,
                                child: Column(
                                  children: [
                                    const Icon(FontAwesome.calendar_check_solid),
                                    const SizedBox(height: 5,),
                                    Text('${data.days} gün'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 60,
                                child: Column(
                                  children: [
                                    const Icon(Icons.ballot_outlined),
                                    const SizedBox(height: 5,),
                                    Text('${data.exams} test'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          ///rating and price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star),
                                  const SizedBox(width: 5,),
                                  Text(data.rating),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(FontAwesome.money_bill_solid, color: Colors.white,),
                                  const SizedBox(width: 5,),
                                  Text('₼ ${data.price}'),
                                ],
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