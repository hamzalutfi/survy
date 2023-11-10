import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:wego/entities/user_entity.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future register(
      {required String name,
      required String lastName,
      required String email,
      required String password,
      required List<String> services,
      required int type}) async {
    String errorMessage = '';
    try {
      print({
        'firstName': name,
        'lastName': lastName,
        'email': email,
        'password': password,
        'type': type,
        'services': services,
        'locations': [],
        'accountStatus': "unverified"
      });
      var result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;
      List<String> locations = [];
      FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'firstName': name,
        'lastName': lastName,
        'email': email,
        'password': password,
        'type': type,
        'services': services,
        'locations': locations,
        'accountStatus': "unverified",
        "connectivity_status": "online"
      });
      print("------> user.uid = ${user.uid}");
      return UserEntity.fromJson({
        'firstName': name,
        'lastName': lastName,
        'email': email,
        'uid': user.uid,
        'type': type,
        'services': services,
        'locations': locations,
        'accountStatus': "unverified",
        "profileURL": ""
      });
    } on FirebaseAuthException catch (e) {
      String message = "error";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong user privded for that user';
      }
      print('message>>'+message);
      errorMessage = generateError(e);
    }
    return errorMessage;
  }

  Future signIn(String email, String password) async {
    String errorMessage = '';
    try {
      dynamic result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;
      print("user ==> $user");
      return user;
    } on FirebaseAuthException catch (e) {
      errorMessage = generateError(e);
      print("----> errorMessage = $errorMessage");
    }
    return errorMessage;
  }

  Future update(
      {required String name,
      required String lastName,
      required String email,
      required String uid,
      required List<String> services,
      required List<String> locations,
      required int type,
      required String accountStatus,
      required String profileURL
      }) async {
    String errorMessage = '';
    try {
      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'firstName': name,
        'lastName': lastName,
        'email': email,
        'uid': uid,
        'type': type,
        'services': services,
        'locations': locations,
        'profileURL': profileURL
      });
      return UserEntity.fromJson({
        'firstName': name,
        'lastName': lastName,
        'email': email,
        'uid': uid,
        'type': type,
        'services': services,
        'locations': locations,
        'accountStatus': accountStatus,
        'profileURL': profileURL
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = generateError(e);
    }
    return errorMessage;
  }

  String generateError(FirebaseAuthException e) {
    String errorMessage = '';
    if (e.code == 'user-not-found') {
      errorMessage = 'User does not exist.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong credentials.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'Invalid email.';
    } else if (e.code == 'user-disabled') {
      errorMessage = 'Disabled user.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'User with this email already exists.';
    } else if (e.code == 'weak-password') {
      errorMessage = 'Weak password.';
    } else {
      errorMessage = 'Error. Try again.';
    }
    return errorMessage;
  }
}
