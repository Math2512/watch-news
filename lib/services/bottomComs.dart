
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/models/commentsModel.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/services/auth.dart';
import 'package:watch_news/services/comments.dart';
import 'package:watch_news/services/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../my_material.dart';

class BottomComments{
  String id;
  String uid;
  List comments;
  BottomComments({this.id, this.comments, this.uid});

  void showModalSheet(context) async {
    showModalBottomSheet(context: context, builder: (builder) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: BoxDecoration(
          color: Color(0xfffcfcff),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: MyDropdownButton(comments: comments, id: id, uid: uid),
      );
    });
  }
}

class MyDropdownButton extends StatefulWidget {

  List comments;
  String id;
  String uid;
  MyDropdownButton({@required this.comments, @required this.id, @required this.uid});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  StreamSubscription streamListener;

  String _comments;

  List<CommentsModel> commentaire = [];
  List<User> users = [];

  List<CommentsModel> getComs(List<DocumentSnapshot> postComs) {
    List<CommentsModel> myList = commentaire;

    postComs.forEach((p) {
      CommentsModel commentaire = CommentsModel(p);
      if (myList.every((p) => p.documentID != commentaire.documentID)) {
        myList.add(commentaire);
      } else {
        CommentsModel toBeChanged = myList.singleWhere((p) => p.documentID == commentaire.documentID);
        myList.remove(toBeChanged);
        myList.add(commentaire);
      }
    });
    return myList;
  }


  getUsers(List<DocumentSnapshot> userDocs) {
    List<User> myList = users;
    userDocs.forEach((u) {
      User user = User(u);
      if (myList.every((p) => p.uid != user.uid)) {
        myList.add(user);
      } else {
        User toBeChanged = myList.singleWhere((p) => p.uid == user.uid);
        myList.remove(toBeChanged);
        myList.add(user);
      }
    });

    setState(() {
      users = myList;
    });
  }





  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
     children: <Widget>[
       Padding(
         padding: const EdgeInsets.all(40.0),
         child: Text('Commentaires'),
       ),
       Row(
         children: <Widget>[
           Expanded(
             flex: 2,
             child: TextField(
               style: TextStyle(color: Colors.black),
               textAlign: TextAlign.center,
               decoration: InputDecoration(
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
                 ),
                 hintText: 'Votre commentaire',
                 hintStyle: TextStyle(color: Colors.grey),
                 enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
                 ),
               ),
               onChanged: (value) {
                 setState(() {
                   _comments = value;
                 });
               },
             ),
           ),
           Expanded(
             flex: 1,
             child: FlatButton(onPressed: () => sendToFirebase(_comments, widget.id, widget.uid), child: Text('Commenter'))
           ),
         ],
       ),
     ],
    );
  }

  sendToFirebase(String Commentaire, String postId, String uid){
    Comments().addPost(uid, Commentaire, postId);
  }


}
