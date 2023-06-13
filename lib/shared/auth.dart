import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> login(String email, String password) async {
    UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    User? user = authResult.user;
    return user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = authResult.user;
    return user!.uid;
  }

  Future<void>? uploadFile(File file) async {
    Reference ref = FirebaseStorage.instance.ref().child("lectures");
    UploadTask uploadTask = ref.putFile(file);
    return null;
  }

  Future<String?> downloadFile() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("lectures/215416612_1904311719725020_5374801225654465202_n.jpg");
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<User?> getUser() async {
    User? user = _firebaseAuth.currentUser;
    return user;
  }
}
