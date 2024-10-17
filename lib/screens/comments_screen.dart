import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkup/resources/firestore_methods.dart';
import 'package:linkup/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widget/Comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Comments',
          style: TextStyle(color: Colors.black), // Set title text color to black
        ),
        centerTitle: false,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Extract comment data
            final comments = (snapshot.data! as dynamic).docs;

            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                // Fade transition for each comment card
                return FadeTransition(
                  opacity: _animation,
                  child: CommentCard(
                    snap: comments[index].data(),
                    color: Colors.white, // Set comment card background color to white
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          color: Colors.white, // Set bottom nav background color to white
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      hintStyle: const TextStyle(color: Colors.black54), // Hint text color
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black), // Text color
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );


                  setState(() {
                    _commentController.text = "";
                    _controller.forward(); // Trigger animation when a comment is posted
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
