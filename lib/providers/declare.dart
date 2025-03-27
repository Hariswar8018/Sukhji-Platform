
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/usermodel.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshuser() async {
    UserModel user = await GetUser();
    _user = user;
    notifyListeners();
  }

  Future<UserModel> GetUser() async {
    String s=FirebaseAuth.instance.currentUser!.uid;
    print(s);
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(s)
        .get();
    print(snap.exists);
    print(s);
    print(snap.data().toString());
    return UserModel.fromSnap(snap);
  }
}