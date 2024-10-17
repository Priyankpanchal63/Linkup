import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkup/utils/colors.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Post Details',
          style: TextStyle(color: Colors.black), // Set app bar title color to black
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').doc(postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Post not found'));
          }

          var postData = snapshot.data!.data() as Map<String, dynamic>;

          return AnimatedOpacity(
            opacity: 1.0, // Animation opacity
            duration: const Duration(milliseconds: 500), // Duration of the fade in
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display post image
                  Image.network(
                    postData['postUrl'],
                    fit: BoxFit.cover, // Ensure the image covers the space
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post description
                        Text(
                          postData['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black, // Set description text color to black
                          ),
                        ),
                        // Likes count
                        const SizedBox(height: 8),
                        Text(
                          '${postData['likes'].length} likes',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Set likes text color to black
                          ),
                        ),
                        const Divider(color: Colors.black), // Set divider color to black
                        // Additional post details can go here
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
