import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/pageheader.dart';
import 'package:mbauser/pages/views/joinCoursePage.dart';

class CourseDetails extends StatefulWidget {
  final String courseId;
  const CourseDetails({super.key, required this.courseId});

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    TabController firstPageController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: Stack(
        children: [
          ///
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [

                  ///header
                  pageHeader(text: 'Kurs haqqında'),


                  ///image
                  SizedBox(height:300, width: double.infinity, child: Image.asset('images/1.jpeg', fit: BoxFit.cover,)),

                  ///body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Kursun adi', style: TextStyle(color: MbaColors.red, fontWeight: FontWeight.bold, fontSize: 20),),
                              Text('qiymet'),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 30,
                            child: TabBar(
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.white,
                              dividerColor: Colors.transparent,
                              indicatorPadding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.zero,
                              indicator: const BoxDecoration(
                                  color: MbaColors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              controller: firstPageController,
                              tabs: [
                                Tab(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesome.list_ul_solid, size: 15,),
                                      SizedBox(width: 10,),
                                      Text('Dərslər'),
                                    ],
                                  ),
                                ),
                                Tab(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesome.book_open_solid, size: 15,),
                                      SizedBox(width: 10,),
                                      Text('Haqqında'),
                                    ],
                                  ),
                                ),
                                Tab(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesome.comments_solid, size: 15,),
                                      SizedBox(width: 10,),
                                      Text('Fikirlər'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 500,
                            child: TabBarView(
                              controller: firstPageController,
                              children: [
                                // Topics Tab
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: topics.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(topics[index]),
                                    );
                                  },
                                ),
                                // About Tab
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'This is a paragraph about the course. You can provide detailed information about the course content, instructors, and target audience here.',
                                  ),
                                ),
                                // Reviews Tab
                                ListView.builder(
                                  itemCount: reviews.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(reviews[index].name),
                                      subtitle: Text(reviews[index].review),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ///button,

          Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MbaButton(callback: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JoinCoursePage(courseId: 'asdasdasd',)));
                }, bgColor: MbaColors.red, text: 'Qoşul'),
              )
          ),
        ],
      ),
    );
  }

  List<String> topics = ['Topic 1', 'Topic 2', 'Topic 3','Topic 1', 'Topic 2', 'Topic 3','Topic 1', 'Topic 2', 'Topic 3'];

  List<Review> reviews = [
    Review(name: 'John Doe', review: 'Great course!'),
    Review(name: 'Jane Doe', review: 'Very informative.'),
  ];
}

class Review {
  final String name;
  final String review;

  Review({required this.name, required this.review});
}
