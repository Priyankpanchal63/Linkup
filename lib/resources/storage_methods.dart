import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Adding image to Firebase Storage
  Future<String> uplodImageToStorage(String childName, Uint8List file, bool isPost) async {
    // Create a reference with the base path
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // If it's a post, add a unique ID to the path to avoid overwriting previous images
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);  // Update the ref to a unique child path
    }

    // Upload the file
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;

    // Get and return the download URL
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}