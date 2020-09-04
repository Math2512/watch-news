

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_news/my_material.dart';

class Post {
  DocumentReference ref;
  String documentID;
  String id;
  String titre;
  String url;
  String uid;
  String imageUrl;
  int date;
  List<dynamic> likes;
  List<dynamic> comments;

  Post(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentID = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    id = map[keyPostID];
    titre = map[keyArticleTitle];
    uid = map[keyUid];
    imageUrl = map[keyImageUrl];
    url     = map[keyArticleUrl];
    date = map[keyDate];
    likes = map[keyLikes];
    comments = map[keyComments];
  }

  Map<String, dynamic>toMap() {
    Map<String, dynamic> map = {
      keyPostID: id,
      keyUid: uid,
      keyImageUrl: imageUrl,
      keyArticleUrl: url,
      keyArticleTitle: titre,
      keyComments: comments,
      keyLikes: likes,
      keyDate: date,
    };
    return map;
  }
}