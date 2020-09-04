import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/my_material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class FireHelper {
  final authInstance=FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String mail, String password) async {
    AuthResult result = await authInstance.signInWithEmailAndPassword(email: mail, password: password);
    return result.user;
  }

  Future<FirebaseUser> createAccount(String mail, String password, String name, String surname) async {
    final FirebaseUser user = (await authInstance.createUserWithEmailAndPassword(email: mail, password: password)).user;
    String uid = user.uid;
    List<dynamic> followers = [uid];
    List<dynamic> following = [];
    Map<String, dynamic> map = {
      keyName: name,
      keySurname: surname,
      keyImageUrl: "",
      keyFollowers: followers,
      keyUid: uid,
      keyFollowing: following
    };

    addUser(uid, map);
    return user;
  }

  // ignore: non_constant_identifier_names
  static final storage_instance = FirebaseStorage.instance.ref();
  // ignore: non_constant_identifier_names
  final storage_user = storage_instance.child('users');

  Future<FirebaseUser> fblogin(String token) async {
    final FirebaseUser newUser = ( await authInstance.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: token))).user;

    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture.width(800).height(800),email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    final snapShot = await Firestore.instance.collection('users').document(newUser.uid).get();

    if (snapShot == null || !snapShot.exists) {
      String uid = newUser.uid;
       List<dynamic> followers = [uid];
       List<dynamic> following = [];
       Map<String, dynamic> map = {
         keyName: profile['last_name'],
         keySurname: profile['first_name'],
         keyImageUrl: profile['picture']['data']['url'],
         keyFollowers: followers,
         keyUid: uid,
         keyFollowing: following
       };

       addUser(uid, map);
     return newUser;
    }
    else{
      print('exist');
    }
  }

  logOut(){
    final facebookLogin = FacebookLogin();
    facebookLogin.logOut();
    authInstance.signOut();
  }

  static final dataInstance = Firestore.instance;
  final fireUser = dataInstance.collection("users");

  addUser(String uid, Map<String, dynamic> map) {
    fireUser.document(uid).setData(map);
}

  Future<String> addImage(File file, StorageReference ref) async {
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;

    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;

  }

  Stream<QuerySnapshot> postsFrom(String uid) => fireUser.document(uid).collection("posts").snapshots();

  addFollow(User other) {
    if (me.uid != other.uid){
    if(me.following.contains(other.uid)){
      me.ref.updateData({keyFollowing: FieldValue.arrayRemove([other.uid])});
      other.ref.updateData({keyFollowers: FieldValue.arrayRemove([me.uid])});
    }else{
      me.ref.updateData({keyFollowing: FieldValue.arrayUnion([other.uid])});
      other.ref.updateData({keyFollowers: FieldValue.arrayUnion([me.uid])});
    }}
  }

  modifyPicture(File file) {
    StorageReference ref = storage_user.child(me.uid);
    addImage(file, ref).then((finalised) {
      Map<String, dynamic> data = {keyImageUrl: finalised};
      modifyUser(data);
    });
  }

  modifyUser(Map<String, dynamic> data) {
    fireUser.document(me.uid).updateData(data);
  }

}