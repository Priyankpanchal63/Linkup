import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkup/resources/auth_methods.dart';
import 'package:linkup/resources/firestore_methods.dart';
import 'package:linkup/screens/edit_profile_screen.dart'; // Create this screen
import 'package:linkup/screens/login_screen.dart';
import 'package:linkup/screens/post_detail_screen.dart'; // Import the new PostDetailScreen
import 'package:linkup/utils/colors.dart';
import 'package:linkup/utils/utils.dart';
import 'package:linkup/widget/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = snap.data()!;
      followers = snap.data()!['followers'].length;
      following = snap.data()!['following'].length;
      isFollowing = snap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void signOut() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          uid: widget.uid,
          currentBio: userData['bio'],
          currentUsername: userData['username'],
          currentPhotoUrl: userData['photoUrl'],
        ),
      ),
    );
  }

  void navigateToPostDetail(String postId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(postId: postId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          userData['username'],
          style: const TextStyle(color: Colors.black), // Set title text color to black
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout, color: Colors.black), // Set icon color to black
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStateColumn(postLen, "posts"),
                              buildStateColumn(followers, "followers"),
                              buildStateColumn(following, "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid
                                  ? FollowButton(
                                text: 'Edit Profile',
                                backgroundColor: Colors.white, // White background
                                textColor: Colors.black, // Black text
                                borderColor: Colors.grey,
                                function: navigateToEditProfile,
                              )
                                  : isFollowing
                                  ? FollowButton(
                                borderColor: Colors.grey,
                                backgroundColor: Colors.white,
                                text: 'Unfollow',
                                textColor: Colors.black,
                                function: () async {
                                  await FirestoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                  setState(() {
                                    isFollowing = false;
                                    followers--;
                                  });
                                },
                              )
                                  : FollowButton(
                                borderColor: Colors.green,
                                backgroundColor: Colors.green,
                                text: 'Follow',
                                textColor: Colors.white,
                                function: () async {
                                  await FirestoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                  setState(() {
                                    isFollowing = true;
                                    followers++;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userData['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Set username text color to black
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userData['bio'],
                    style: const TextStyle(color: Colors.black), // Set bio text color to black
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                  return GestureDetector(
                    onTap: () => navigateToPostDetail(snap.id), // Navigate to post detail
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300), // High-level animation
                      curve: Curves.easeInOut,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Set number text color to black
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
