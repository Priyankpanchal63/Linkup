import 'dart:io';
import 'package:file_picker/file_picker.dart'; // For picking files
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'JobScreen.dart';

class JobApplyScreen extends StatefulWidget {
  final Job job;

  const JobApplyScreen({super.key, required this.job});

  @override
  _JobApplyScreenState createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends State<JobApplyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Variables for form input
  String? userEmail;
  String fullName = '';
  String phoneNumber = '';
  String gender = 'Male'; // Default gender selection
  File? resumeFile; // To store the selected resume file
  String? resumeFileName;
  bool isUploading = false;
  Color uploadButtonColor = Colors.black12; // Default button color

  // Colors for border indication
  Color fullNameBorderColor = Colors.grey;
  Color phoneNumberBorderColor = Colors.grey;
  Color resumeBorderColor = Colors.grey;

  @override
  void initState() {
    super.initState();

    // Set up animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward(); // Start the animation

    // Fetch current user's email
    _getUserEmail();
  }

  void _getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email ?? 'No Email';
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  // Function to pick a PDF file
  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        resumeFile = File(result.files.single.path!);
        resumeFileName = result.files.single.name;
        resumeBorderColor = Colors.grey; // Reset resume border color on new selection
      });
    } else {
      // User canceled the picker or selected no file
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected. Please choose a PDF file.')),
      );
    }
  }

  // Function to upload resume to Firebase Storage and return the file URL
  Future<String?> _uploadResume() async {
    if (resumeFile == null) return null;

    setState(() {
      isUploading = true;
      uploadButtonColor = Colors.black12; // Reset to original color during upload
    });

    try {
      String filePath = 'resumes/${widget.job.role}_${userEmail}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(filePath)
          .putFile(resumeFile!);

      TaskSnapshot snapshot = await uploadTask;
      String resumeUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        isUploading = false;
        uploadButtonColor = Colors.green; // Change button color to green after upload
      });

      return resumeUrl;
    } catch (e) {
      print('Error uploading resume: $e');
      setState(() {
        isUploading = false;
        uploadButtonColor = Colors.black12; // Reset to original color on error
      });
      return null;
    }
  }

  // Function to submit the application data to Firestore
  Future<void> _submitApplication() async {
    // Reset border colors
    setState(() {
      fullNameBorderColor = Colors.grey;
      phoneNumberBorderColor = Colors.grey;
      resumeBorderColor = Colors.grey;
    });

    bool hasError = false;

    // Validate required fields
    if (fullName.isEmpty) {
      setState(() {
        fullNameBorderColor = Colors.red; // Set border color to red if empty
      });
      hasError = true;
    }
    if (phoneNumber.isEmpty) {
      setState(() {
        phoneNumberBorderColor = Colors.red; // Set border color to red if empty
      });
      hasError = true;
    }
    if (resumeFile == null) {
      setState(() {
        resumeBorderColor = Colors.red; // Set border color to red if no resume uploaded
      });
      hasError = true;
    }

    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    // Upload resume to Firebase Storage and get the file URL
    String? resumeUrl = await _uploadResume();

    if (resumeUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload resume. Please try again.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('job_applications').add({
        'companyName': widget.job.companyName,
        'role': widget.job.role,
        'fullName': fullName,
        'email': userEmail,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'resumeUrl': resumeUrl, // Store the resume URL in Firestore
        'appliedAt': Timestamp.now(), // Store the time of application
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Applied successfully for ${widget.job.role} at ${widget.job.companyName}')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting application: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit application. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for ${widget.job.role}', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _animation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apply for ${widget.job.role} at ${widget.job.companyName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')), // Allow only letters and spaces
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.lightBlue), // Sky blue icon
                    hintText: 'Enter your Full Name',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: fullNameBorderColor), // Use dynamic color
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    fullName = value;
                  },
                ),
                SizedBox(height: 10),
                // Read-only Email field
                TextField(
                  controller: TextEditingController(text: userEmail), // Set the email in the controller
                  readOnly: true, // Make it read-only
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.lightBlue), // Sky blue icon
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey), // Keep email border normal
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.phone, // Allow only phone input
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone, color: Colors.lightBlue), // Sky blue icon
                    hintText: 'Enter your Phone Number',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: phoneNumberBorderColor), // Use dynamic color
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Gender: ', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    Text('Male', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    Text('Female', style: TextStyle(color: Colors.black)),
                  ],
                ),
                SizedBox(height: 10),
                // Icon button for uploading PDF
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _pickResume,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: uploadButtonColor, // Change button color dynamically
                        foregroundColor: Colors.white, // White button text
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.upload_file), // Upload icon
                          SizedBox(width: 5),
                          Text('Upload Resume (PDF)'),
                        ],
                      ),
                    ),
                    // Read-only text field for selected resume
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: resumeBorderColor), // Use dynamic color for resume
                      ),
                      child: Text(
                        resumeFileName ?? 'No file selected',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isUploading ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue, // Sky blue button
                    foregroundColor: Colors.white, // White button text
                  ),
                  child: Text(isUploading ? 'Uploading...' : 'Submit Application'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
