import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mbauser/elements/colors.dart';
import '../../elements/pageheader.dart';
import '../../models/event.dart';
import '../../models/news.dart';


class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref('posts');
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<dynamic> loadedPosts = [];
        data.forEach((key, value) {
          if (value['type'] == 'news') {
            loadedPosts.add(News.fromMap(value)); // Ensure News.fromMap is correct
          } else if (value['type'] == 'event') {
            loadedPosts.add(Event.fromMap(value)); // Ensure Event.fromMap is correct
          }
        });

        // Sort the posts by dateAdded or date
        loadedPosts.sort((a, b) {
          final dateA = a is News ? a.date : (a as Event).dateAdded;
          final dateB = b is News ? b.date : (b as Event).dateAdded;
          return dateB.compareTo(dateA); // Sort by newest first
        });

        setState(() {
          _posts = loadedPosts;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            pageHeader(text: 'Yeniliklər'),
            Expanded(
              child: _posts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  if (post is News) {
                    return NewsTile(news: post);
                  } else if (post is Event) {
                    return ListTile(
                      title: Text('Event: ' + post.title),
                      subtitle: Text('${post.about}\nLocation: ${post.date}\nTime: ${post.price}'),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
    );
  }
}


class NewsTile extends StatelessWidget {
  final News news;

  const NewsTile({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            border: Border.all(
                color: MbaColors.red, width: 1, style: BorderStyle.solid)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      news.image,
                      fit: BoxFit.cover, // Stretch image to cover the container
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                news.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: MbaColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                          color: MbaColors.red,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, right: 4, top: 4, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                news.text,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //badge
            Positioned(
                right: 10,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: MbaColors.red,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(5))),
                  child: Center(
                    child: Icon(
                      Icons.newspaper,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
