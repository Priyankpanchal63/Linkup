import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:linkup/models/post.dart';
import 'package:linkup/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //uplode a post
   Future<String>uploadPost(
       String description,
       Uint8List file,
       String uid,
       String username,
       String profImage
       )async{
     String res="Some error occured";
     try{
         String photoUrl=await StorageMethods().uplodImageToStorage('posts', file, true) ;
         String postId=const Uuid().v1();
         Post post =Post(
             description: description,
             uid: uid,
             username: username,
             datePublished: DateTime.now(),
             postId: postId,
             postUrl: photoUrl,
             profImage: profImage,
             likes: []
         );
         _firestore.collection('posts').doc(postId).set(
           post.toJson());
         res="success";
     }
     catch(err){
         res=err.toString();
     }
     return res;
   }
   Future<void>likePost(String postId,String uid,List likes)async{
     try {
       if (likes.contains(uid)) {
         _firestore.collection('posts').doc(postId).update({
           'likes': FieldValue.arrayRemove([uid]),
         });
       }
       else {
         _firestore.collection('posts').doc(postId).update({
           'likes': FieldValue.arrayUnion([uid]),
         });
       }
     }
     catch(e){
       print(e.toString(),);
     }
   }
   Future<void>postComment(String postId,String text,String uid,String name,String profilePic)async {
     try {
       if (text.isNotEmpty) {
         String commentId = const Uuid().v1();
         await _firestore.collection('posts').doc(postId)
             .collection('comments')
             .doc(commentId)
             .set(
             {
               'profilePic': profilePic,
               'name': name,
               'uid': uid,
               'text': text,
               'commentId': commentId,
               'datePublished': DateTime.now(),
             });
       }
       else {
         print('Text is empty');
       }
     } catch (e) {
       print(e.toString());
     }
   }
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
   }
   Future<void>followUser(
       String uid,
       String followId
       )async{
     try{
      DocumentSnapshot snap=await _firestore.collection('users').doc(uid).get();
      List following=(snap.data()! as dynamic)['following'];
      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers':FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following':FieldValue.arrayRemove([followId])
        });
      }
      else{
        await _firestore.collection('users').doc(followId).update({
          'followers':FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following':FieldValue.arrayUnion([followId])
        });
      }
     }
     catch(e){
       if(kDebugMode)print(e.toString());
     }
   }
}