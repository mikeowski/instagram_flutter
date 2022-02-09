import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  //Sign up the user
  Future<String> signUpUser({
    required String userName,
    required String password,
    required String email,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty ||
          userName.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        // add user to fireStore

        await _fireStore.collection('users').doc(cred.user!.uid).set({
          'username': userName,
          'email': email,
          'bio': bio,
          'uid': cred.user!.uid,
          'fallowers': [],
          'fallowing': [],
          'photoUrl': photoUrl,
        });
        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
