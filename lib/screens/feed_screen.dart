import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/widget/post_card.dart';
import 'package:flutter/animation.dart';

import '../utils/gloable_variable.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  // Map to store user data for quick access (caching)
  Map<String, Map<String, dynamic>> userDataCache = {};

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this,
    );

    // Slide animation from bottom to top
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    if (userDataCache.containsKey(uid)) {
      // If user data is already cached, return it
      return userDataCache[uid]!;
    } else {
      // Fetch user data from Firestore and cache it
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      var userData = userDoc.data() as Map<String, dynamic>;
      userDataCache[uid] = userData; // Cache the user data
      return userData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      appBar: width > webScreenSize
          ? null
          : AppBar(
        backgroundColor: Colors.white, // AppBar background color set to white
        centerTitle: false,
        title: Image.asset('assets/linkup.png', height: 32),
        elevation: 0, // Remove shadow from AppBar
        actions: [
          IconButton(
            icon: const Icon(
              Icons.messenger_outline,
              color: Colors.black, // Change icon color to black
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // When data is available, trigger the animation
          _controller.forward();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var postData = snapshot.data!.docs[index].data();

              // Fetch updated user information dynamically
              return FutureBuilder(
                future: getUserData(postData['uid']), // Use the getUserData method to fetch user data
                builder: (context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const SizedBox(); // Or show a loading indicator
                  }

                  var userData = userSnapshot.data!;

                  // Pass the updated user data (name and photo) to PostCard
                  return SlideTransition(
                    position: _offsetAnimation, // Apply slide animation
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500), // Fade-in animation
                      opacity: 1.0,
                      child: Container(
                        color: Colors.white, // Set container background color to white
                        padding: const EdgeInsets.symmetric(vertical: 8.0), // Add spacing between posts
                        child: PostCard(
                          snap: postData,
                          userName: userData['username'], // Use cached user data
                          userPhoto: userData['photoUrl'],
                          fontColor: Colors.black, // Ensure text color is black
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
