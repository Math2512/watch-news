import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_news/my_material.dart';

class User {
  String uid;
  String name;
  String surname;
  String imageUrl;
  List<dynamic> followers;
  List<dynamic> following;
  DocumentReference ref;
  String documentId;
  String description;

  User(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentId = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    uid = map[keyUid];
    name = map[keyName];
    surname = map[keySurname];
    followers = map[keyFollowers];
    following = map[keyFollowing];
    imageUrl = map[keyImageUrl];
    description = map[keyDescription];
  }
  Map<String, dynamic>toMap() {
    return {
      keyUid: uid,
      keyName: name,
      keySurname: surname,
      keyImageUrl: imageUrl,
      keyFollowing: following,
      keyFollowers: followers,
      keyDescription: description,

    };
  }
}