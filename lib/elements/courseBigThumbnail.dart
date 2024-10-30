import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/models/courseData.dart';
import 'package:mbauser/pages/views/courseDetails.dart';
import 'colors.dart';

class CourseBigThumbnail extends StatelessWidget {
  final CourseData data;

  const CourseBigThumbnail({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 0,
                  offset: Offset.zero
              )
            ] 
          ),
          child: Row(
            children: [
              // Course image
              SizedBox(
                height: 130,
                width: 170,
                child: ClipRRect(borderRadius: BorderRadius.horizontal(left:Radius.circular(10)), child: Image.network(data.imageUrl, fit: BoxFit.cover)), // Changed to network image
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                    color: MbaColors.lightRed3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///title
                        Row(
                          children: [
                            Text(
                              data.name,
                              style: const TextStyle(
                                  color: MbaColors.red, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ///icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Lessons count
                            cardItem(data: data.lessons.length.toString(), icon: Icons.play_lesson, label: 'dərs'),
                            cardItem(data: data.lessons.length.toString(), icon: FontAwesome.calendar_check_solid, label: 'dərs'),
                            cardItem(data: data.lessons.length.toString(), icon: Icons.ballot_outlined, label: 'dərs'),
                          ],
                        ),
                        ///rating and price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Rating
                            Container(
                              decoration: BoxDecoration(
                                color: MbaColors.dark,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
                                child: Row(
                                  children: [
                                    Text(data.rating.toString(), style: TextStyle(color: MbaColors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                                    SizedBox(width: 5),
                                    Icon(Icons.star, color: Colors.amberAccent, size: 14,),
                                  ],
                                ),
                              ),
                            ),
                            // Price
                            Container(
                              decoration: BoxDecoration(
                                color: MbaColors.red,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                child: Row(
                                  children: [
                                    Text('₼ ${data.price}', style: TextStyle(color: MbaColors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Navigate to course details on tap
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetails(course: data)),
        );
      },
    );
  }
}

class cardItem extends StatelessWidget {
  final String data;
  final IconData icon;
  final String label;

  const cardItem({
    super.key,
    required this.data,
    required this.icon,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      child: Column(
        children: [
          Icon(icon, color: MbaColors.dark, size: 18,),
          const SizedBox(height: 3),
          Text('$data $label', style: TextStyle(color: MbaColors.dark, fontWeight: FontWeight.bold),), // Updated lesson count
        ],
      ),
    );
  }
}
