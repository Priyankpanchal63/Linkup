import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:linkup/screens/profile_screen.dart';
import 'package:linkup/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background color white
        elevation: 1,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for user...',
              labelStyle: TextStyle(color: Colors.black), // Text color set to black
            ),
            style: const TextStyle(color: Colors.black), // Input text color to black
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isShowUsers
            ? FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where(
            'username',
            isGreaterThanOrEqualTo: searchController.text,
          )
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: (snapshot.data! as dynamic).docs[index]['uid'],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        (snapshot.data! as dynamic).docs[index]['photoUrl'],
                      ),
                      radius: 20,
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['username'],
                      style: const TextStyle(color: Colors.black), // Text color black
                    ),
                  ),
                );
              },
            );
          },
        )
            : FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return MasonryGridView.count(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemBuilder: (context, index) {
                final postUrl = (snapshot.data! as dynamic).docs[index]['postUrl'];
                return GestureDetector(
                  onTap: () {
                    // Add any action or animation you want on image tap
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for images
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png', // Placeholder while loading
                        image: postUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
