import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/models/post.dart' as modelPost;
import 'package:watch_news/my_material.dart';

class Post{

  static final dataInstance = Firestore.instance;
  final fireUser = dataInstance.collection("users");

  static final storage_instance = FirebaseStorage.instance.ref();
  final storage_user = storage_instance.child('users');
  final storage_posts = storage_instance.child('posts');

  Future<String> addImage(File file, StorageReference ref) async {
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;

    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;

  }

  addPost(String uid, String titre, imageUrl, url) {
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    Map<String, dynamic> map = {
      keyUid: uid,
      keyImageUrl: imageUrl,
      keyArticleUrl: url,
      keyArticleTitle: titre,
      keyComments: comments,
      keyLikes: likes,
      keyDate: date,
  };


    fireUser.document(uid).collection("posts").document().setData(map);

  }

  addlike(modelPost.Post other, User me) {
      if (other.likes.contains(other.uid) || other.likes.contains(me.uid)) {
        me.ref.updateData({keyLikes: FieldValue.arrayRemove([other.uid])});
        other.ref.updateData({keyLikes: FieldValue.arrayRemove([me.uid])});
      } else {
        me.ref.updateData({keyLikes: FieldValue.arrayUnion([other.uid])});
        other.ref.updateData({keyLikes: FieldValue.arrayUnion([me.uid])});
      }
  }

}