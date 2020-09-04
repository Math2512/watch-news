import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/my_material.dart';

class Comments {

  static final dataInstance = Firestore.instance;
  final fireUser = dataInstance.collection("users");

  static final storage_instance = FirebaseStorage.instance.ref();
  final storage_user = storage_instance.child('users');
  final storage_notif = storage_instance.child('comments');

  addPost(String uid, String commentaire, String postId) {

    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    Map<String, dynamic> map = {
      keyUid: uid,
      keyComments: commentaire,
      keyPostID: postId,
      keyDate: date
    };


    fireUser.document(uid).collection("comments").document().setData(map);
  }
}