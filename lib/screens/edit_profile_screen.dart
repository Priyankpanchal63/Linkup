import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/utils/utils.dart';
import '../widget/text_field_input.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  final String currentBio;
  final String currentUsername;
  final String currentPhotoUrl;

  const EditProfileScreen({
    super.key,
    required this.uid,
    required this.currentBio,
    required this.currentUsername,
    required this.currentPhotoUrl,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _bioFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.currentUsername;
    _bioController.text = widget.currentBio;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _usernameFocusNode.dispose();
    _bioFocusNode.dispose();
    super.dispose();
  }

  // Pick image from gallery
  Future<void> selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? photoUrl = widget.currentPhotoUrl;
      if (_image != null) {
        // Upload new profile picture
        String filePath = 'profilePics/${widget.uid}.jpg';
        TaskSnapshot snap = await FirebaseStorage.instance
            .ref(filePath)
            .putData(_image!);
        photoUrl = await snap.ref.getDownloadURL();
      }

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'username': _usernameController.text,
        'bio': _bioController.text,
        'photoUrl': photoUrl,
      });

      showSnackBar('Profile updated successfully', context);
      Navigator.of(context).pop();
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black), // Black color for title
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.check, color: Colors.black), // Black color for check icon
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white, // Set total white background
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
            children: [
              // Profile Picture Section with Animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300), // Animation duration
                curve: Curves.easeInOut,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : NetworkImage(widget.currentPhotoUrl) as ImageProvider,
                      backgroundColor: Colors.grey,
                    ),
                    Positioned(
                      bottom: -10,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _image == null ? 1.0 : 0.0, // Fade in/out based on image selection
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo, size: 30, color: Colors.black),
                          onPressed: selectImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // Add spacing between profile picture and username

              // Display Current Username
              Text(
                widget.currentUsername,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black color for username text
                ),
              ),
              const SizedBox(height: 24),

              // Username TextField with Animation
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _usernameFocusNode.hasFocus ? Colors.lightBlue.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _usernameFocusNode.hasFocus ? Colors.lightBlue : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: TextFieldInput(
                    focusNode: _usernameFocusNode,
                    textEditingController: _usernameController,
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bio TextField with Animation
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _bioFocusNode.hasFocus ? Colors.lightBlue.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _bioFocusNode.hasFocus ? Colors.lightBlue : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: TextFieldInput(
                    focusNode: _bioFocusNode,
                    textEditingController: _bioController,
                    hintText: 'Enter your bio',
                    textInputType: TextInputType.text,
                  ),
                ),
              ),
              const SizedBox(height: 50), // Added extra spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
