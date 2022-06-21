import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload a post

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        username: username,
        uid: uid,
        postUrl: photoUrl,
        postId: postId,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //delete post

  Future<String> deletePost(String postId, bool isAccess) async {
    String res = 'some error occured';
    try {
      if (isAccess) {
        await _firestore.collection('posts').doc(postId).delete();
        res = 'Success';
      } else {
        res = 'You can not delete this post';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = 'some error occured';
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'text': text,
          'uid': uid,
          'likes': [],
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = 'Text is empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> fallowUser(
    String uid,
    String followingId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];

      if (following.contains(followingId)) {
        await _firestore.collection("users").doc(followingId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([followingId]),
        });
      } else {
        await _firestore.collection("users").doc(followingId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([followingId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
