import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_news/my_material.dart';

class Notif {
  DocumentReference ref;
  String documentID;
  String notification;
  String uid;
  String userId;
  int date;

  Notif(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentID = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    notification = map[keyNotifs];
    uid = map[keyUid];
    userId = map[keyUserId];
    date = map[keyDate];
  }

  Map<String, dynamic>toMap() {
    Map<String, dynamic> map = {
      keyNotifs: notification,
      keyUid: uid,
      keyUserId: userId,
      keyDate: date
    };
    return map;
  }
}