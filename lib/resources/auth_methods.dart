import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkup/resources/storage_methods.dart';
import 'package:linkup/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Sign-up user with email verification
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // Create user with Firebase authentication
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Send email verification
        await cred.user!.sendEmailVerification();

        String photoUrl = await StorageMethods()
            .uplodImageToStorage('profilePics', file, false);

        // Add user to the database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = "Success! Please verify your email.";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Login user and check if email is verified
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // Sign in user
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // Check if email is verified
        if (cred.user!.emailVerified) {
          res = "success";
        } else {
          res = "Please verify your email before logging in.";
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Resend email verification
  Future<String> resendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return "Verification email sent!";
      } else {
        return "User is either not logged in or email already verified.";
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Reset password
  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
