import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/pageheader.dart';
import '../../models/courseData.dart'; // Import CourseData model
import 'joinCoursePage.dart';

class CourseDetails extends StatefulWidget {
  final CourseData course; // Accept CourseData object
  const CourseDetails({super.key, required this.course});

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> with TickerProviderStateMixin {
  bool isVideoPlaying = false;
  late YoutubePlayerController _youtubeController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.course.videoUrl.isNotEmpty) {
      _startVideo();
    }
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _tabController.dispose();
    super.dispose();
  }


  void _startVideo() {
    setState(() {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.course.videoUrl)!,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          enableCaption: false,
        ),
      )..addListener(() {
        if (_youtubeController.value.playerState == PlayerState.ended) {
          setState(() {
            isVideoPlaying = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// Header
                const pageHeader(text: 'Kurs haqqında'),

                /// Image or Video Section
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      // Show image if video is not playing
                      if (!isVideoPlaying)
                        Image.network(
                          widget.course.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),

                      // Show play button if the video is not playing and there's a video URL
                      if (!isVideoPlaying && widget.course.videoUrl.isNotEmpty)
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.play_circle_fill, size: 70, color: MbaColors.red),
                              onPressed: () {
                                setState(() {
                                  isVideoPlaying = true; // Switch to video
                                  _startVideo(); // Restart the video from the beginning
                                });
                              },
                            ),
                          ),
                        ),

                      // Show the YouTube player when the video starts
                      if (isVideoPlaying && widget.course.videoUrl.isNotEmpty)
                        YoutubePlayer(
                          controller: _youtubeController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.red,
                        ),
                    ],
                  ),
                ),

                /// Course Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.course.name, // Course name
                            style: const TextStyle(
                                color: MbaColors.dark, fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: MbaColors.lightRed3,
                              borderRadius: BorderRadius.circular(5)
                            ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '₼ ${widget.course.price}',
                                  style: TextStyle(color: MbaColors.red, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              )
                          ), // Course price
                        ],
                      ),
                      const SizedBox(height: 20),
                      /// Tab Bar
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: MbaColors.lightRed3
                        ),
                        child: TabBar(
                          unselectedLabelColor: MbaColors.dark,
                          dividerColor: Colors.transparent,
                          labelColor: MbaColors.red,
                          indicatorPadding: EdgeInsets.all(1),
                          labelPadding: EdgeInsets.zero,
                          indicator: const BoxDecoration(
                            color: MbaColors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          controller: _tabController,
                          tabs: const [
                            Tab(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesome.list_ul_solid, size: 15),
                                  SizedBox(width: 10),
                                  Text('Dərslər'),
                                ],
                              ),
                            ),
                            Tab(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesome.book_open_solid, size: 15),
                                  SizedBox(width: 10),
                                  Text('Haqqında'),
                                ],
                              ),
                            ),
                            Tab(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesome.comments_solid, size: 15),
                                  SizedBox(width: 10),
                                  Text('Fikirlər'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      /// Tab Bar Views
                      SizedBox(
                        height: 350,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            /// Lessons Tab
                            ListView.builder(
                              shrinkWrap: true,
                              clipBehavior: Clip.none, // Ensures scrolling items are not clipped
                              itemCount: widget.course.lessons.length, // Course lessons
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: MbaColors.lightRed3,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                     // Background color set on the container
                                    child: ListTile(
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          color: MbaColors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color: MbaColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        widget.course.lessons[index],
                                        style: TextStyle(
                                          color: MbaColors.dark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            /// About Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.course.about, textAlign: TextAlign.justify, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MbaColors.dark),),
                                  )), // Course description
                            ),
                            /// Reviews Tab
                            ListView.builder(
                              itemCount: widget.course.reviews.length, // Course reviews
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MbaColors.lightRed3
                                    ),
                                    child: ListTile(
                                      title: Text(widget.course.reviews[index].username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MbaColors.red),),
                                      subtitle: Text(widget.course.reviews[index].review, style: TextStyle(color: MbaColors.dark, fontWeight: FontWeight.normal, fontSize: 14),),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          color: MbaColors.white,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(widget.course.reviews[index].rating % 0.5 == 0 ? FontAwesome.star_solid : FontAwesome.star_half_solid, color: Colors.amberAccent, size: 25,),
                                              SizedBox(height: 2,),
                                              Text(widget.course.reviews[index].rating.toString(), style: TextStyle(color: MbaColors.dark, fontWeight: FontWeight.bold, fontSize: 14),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            /// Join Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MbaButton(
                  callback: () {
                    // Navigate to JoinCoursePage with course data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinCoursePage(course: widget.course), // Pass course data
                      ),
                    );
                  },
                  bgColor: MbaColors.red,
                  text: 'Qoşul',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
