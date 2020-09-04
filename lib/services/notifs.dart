import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/my_material.dart';

class Notifs {

  static final dataInstance = Firestore.instance;
  final fireUser = dataInstance.collection("users");

  static final storage_instance = FirebaseStorage.instance.ref();
  final storage_user = storage_instance.child('users');
  final storage_notif = storage_instance.child('notifications');

  addPost(String uid, String Notifs, String userId) {

    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    Map<String, dynamic> map = {
      keyUid: uid,
      keyNotifs: Notifs,
      keyUserId: userId,
      keyDate: date
    };


    fireUser.document(uid).collection("notifications").document().setData(map);
  }
}