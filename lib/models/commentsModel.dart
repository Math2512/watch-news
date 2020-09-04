import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_news/my_material.dart';

class CommentsModel {
  DocumentReference ref;
  String documentID;
  String Commentaire;
  String uid;
  String userId;
  int date;

  CommentsModel(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentID = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    Commentaire = map[keyNotifs];
    uid = map[keyUid];
    userId = map[keyUserId];
    date = map[keyDate];
  }

  Map<String, dynamic>toMap() {
    Map<String, dynamic> map = {
      keyComments: Commentaire,
      keyUid: uid,
      keyPostID: userId,
      keyDate: date
    };
    return map;
  }
}