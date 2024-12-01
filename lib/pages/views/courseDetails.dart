import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/pageheader.dart';
import '../../models/courseData.dart';
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
                const pageHeader(text: 'Kurs haqqında'),

                // Image or Video Section
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      if (!isVideoPlaying)
                        Image.network(
                          widget.course.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      if (!isVideoPlaying && widget.course.videoUrl.isNotEmpty)
                        Positioned(
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.play_circle_fill, size: 70, color: MbaColors.red),
                              onPressed: () {
                                setState(() {
                                  isVideoPlaying = true;
                                  _startVideo();
                                });
                              },
                            ),
                          ),
                        ),
                      if (isVideoPlaying)
                        YoutubePlayer(
                          controller: _youtubeController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.red,
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.course.name,
                            style: const TextStyle(
                                color: MbaColors.dark, fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: MbaColors.lightRed3,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '₼ ${widget.course.price}',
                                style: const TextStyle(
                                    color: MbaColors.red, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Tab Bar
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MbaColors.lightRed3
                        ),
                          child: TabBar(
                            unselectedLabelColor: MbaColors.dark,
                            labelColor: MbaColors.red,
                            labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            dividerColor: Colors.transparent,
                            overlayColor: WidgetStateColor.transparent,
                            indicator: const BoxDecoration(
                              color: MbaColors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: EdgeInsets.all(2),
                            controller: _tabController,
                           tabs: const [
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesome.list_ul_solid, size: 16),
                                    SizedBox(width: 10),
                                    Text('Dərslər', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesome.book_open_solid, size: 16),
                                    SizedBox(width: 10),
                                    Text('Ətraflı', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesome.comments_solid, size: 16),
                                    SizedBox(width: 10),
                                    Text('Fikirlər', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 350,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.course.lessons.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: MbaColors.lightRed3,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        decoration: const BoxDecoration(
                                          color: MbaColors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                              color: MbaColors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(widget.course.lessons[index], style: TextStyle(color: MbaColors.dark, fontSize: 14, fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(widget.course.about,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                            ListView.builder(
                              itemCount: widget.course.reviews.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return  Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: ListTile(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      tileColor: MbaColors.lightRed3,
                                      title: Text(widget.course.reviews[index].username,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      subtitle: Text(widget.course.reviews[index].review, style: TextStyle(fontSize: 14),),
                                      trailing: Column(
                                        children: [
                                          Icon(FontAwesome.star_solid, color: Colors.orangeAccent,),
                                          SizedBox(height: 5,),
                                          Text(widget.course.reviews[index].rating.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MbaColors.dark),)
                                        ],
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
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MbaButton(
                  callback: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinCoursePage(course: widget.course),
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
