import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkup/resources/firestore_methods.dart';
import 'package:linkup/screens/comments_screen.dart';
import 'package:linkup/widget/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/user_provider.dart';
import 'package:linkup/screens/profile_screen.dart'; // Import the ProfileScreen

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final String userName;
  final String userPhoto;

  const PostCard({
    super.key,
    required this.snap,
    required this.userName,
    required this.userPhoto, required Color fontColor,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimation = false;
  int commentLen = 0;
  bool _isProfileTapped = false; // Track if the profile was tapped

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300, // Light grey border for a clean look
        ),
        color: Colors.white, // Changed background to white
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle profile tap with scaling animation
                    setState(() {
                      _isProfileTapped = true;
                    });
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => ProfileScreen(uid: widget.snap['uid']),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    ).then((_) {
                      setState(() {
                        _isProfileTapped = false; // Reset after transition
                      });
                    });
                  },
                  child: Hero(
                    tag: 'profile_${widget.snap['uid']}', // Unique tag for hero transition
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(widget.userPhoto),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () {
                        // Same scaling effect on username tap
                        setState(() {
                          _isProfileTapped = true;
                        });
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ProfileScreen(uid: widget.snap['uid']),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        ).then((_) {
                          setState(() {
                            _isProfileTapped = false; // Reset after transition
                          });
                        });
                      },
                      child: Text(
                        widget.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                    ),
                  ),
                ),
                // Delete Option
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Post", style: TextStyle(color: Colors.black)), // Black title text
                        content: const Text(
                          "Are you sure you want to delete this post?",
                          style: TextStyle(color: Colors.black), // Black content text
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () async {
                              String res = await FirestoreMethods().deletePost(widget.snap['postId']);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
                            },
                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert, color: Colors.black), // Icon color to black
                ),
              ],
            ),
          ),
          // Post Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'].toString(),
                  user!.uid,
                  widget.snap['likes']);
              setState(() {
                isLikeAnimation = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.contain,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimation ? 1 : 0,
                  child: LikeAnimation(
                    isAnimation: isLikeAnimation,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimation = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Like and Comment Section
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimation: widget.snap['likes'].contains(user!.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border, color: Colors.black), // Unliked icon black
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(snap: widget.snap),
                  ),
                ),
                icon: const Icon(Icons.comment_outlined, color: Colors.black), // Comment icon black
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send, color: Colors.black), // Send icon black
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border, color: Colors.black), // Bookmark icon black
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          // Post Description and Comment Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set text color to black
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Set text color to black
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                          style: const TextStyle(color: Colors.black), // Set description text color to black
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black, // Comment text black
                      ),
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
