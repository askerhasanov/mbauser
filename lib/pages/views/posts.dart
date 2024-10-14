import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
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

  // Add a StreamSubscription to manage the listener
  StreamSubscription<DatabaseEvent>? _postsSubscription;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    // Assign the listener to the StreamSubscription
    _postsSubscription = _databaseReference.onValue.listen((event) {
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

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            _posts = loadedPosts;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _postsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MbaColors.light,
      child: Column(
        children: [
          // Header
          const pageHeader(text: 'Yeniliklər'),
          Expanded(
            child: _posts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                if (post is News) {
                  return NewsTile(news: post);
                } else if (post is Event) {
                  return EventTile(event: post);
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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  news.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: MbaColors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: const BoxDecoration(
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
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Badge
            Positioned(
                right: 10,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: MbaColors.red,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(5))),
                  child: const Center(
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

class EventTile extends StatefulWidget {
  final Event event;

  const EventTile({super.key, required this.event});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool isFaved = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      widget.event.image,
                      fit: BoxFit.cover, // Stretch image to cover the container
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              // Title and favorite icon
                              Expanded(
                                child: Text(
                                  widget.event.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: MbaColors.black),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isFaved = !isFaved;
                                    });
                                  },
                                  icon: Icon(
                                    isFaved
                                        ? FontAwesome.heart_solid
                                        : FontAwesome.heart,
                                    color: MbaColors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 4, top: 4, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.event.about,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 4, top: 4, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesome.calendar,
                                      color: MbaColors.red,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat('dd, MMM, yy').format(
                                          DateTime.parse(widget.event.date)),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesome.clock,
                                      color: MbaColors.red,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat('HH:mm').format(
                                          DateTime.parse(widget.event.date)),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: MbaColors.red,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Bootstrap.ticket,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        widget.event.isPayed
                                            ? widget.event.price
                                            : 'Pulsuz',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Badge
            Positioned(
                right: 10,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: MbaColors.red,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(5))),
                  child: const Center(
                    child: Icon(
                      Icons.calendar_month,
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
