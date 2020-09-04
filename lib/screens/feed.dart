
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/models/post.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/screens/notifications.dart';
import 'package:watch_news/screens/profile.dart';
import 'package:watch_news/screens/usersList.dart';
import 'package:watch_news/services/auth.dart';
import 'package:watch_news/services/bottomModal.dart';
import 'package:watch_news/services/bottomComs.dart';
import 'package:watch_news/services/notifs.dart';
import 'package:watch_news/services/post.dart' as postadd;
import '../my_material.dart';
import 'package:date_format/date_format.dart';


class FeedScreen extends StatefulWidget {

  String uid;
  FeedScreen({@required this.uid});

  static String id = 'feed';

  @override
  _FeedScreen createState() => _FeedScreen();
}

class _FeedScreen extends State<FeedScreen> {

  StreamSubscription sub;
  List<Post> posts = [];
  List<User> users = [];
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupSub();
  }


  void goTo(String idScreen){
    Navigator.pushNamed(context, idScreen);
  }

  List<Post> getPosts(List<DocumentSnapshot> postDocs) {
    List<Post> myList = posts;

    postDocs.forEach((p) {
      Post post = Post(p);
      if (myList.every((p) => p.documentID != post.documentID)) {
        myList.add(post);
      } else {
        Post toBeChanged = myList.singleWhere((p) => p.documentID == post.documentID);
        myList.remove(toBeChanged);
        myList.add(post);
      }
    });
    myList.sort((a, b) => b.date.compareTo(a.date));
    return myList;
  }

  setupSub() {
    sub = FireHelper().fireUser.where(keyFollowers, arrayContains: me.uid).snapshots().listen((datas) {
      getUsers(datas.documents);
      datas.documents.forEach((docs) {
        docs.reference.collection("posts").snapshots().listen((post) {
          var postDocs = post.documents;
          setState(() {
            posts = getPosts(postDocs);
          });
        });
      });
    });
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
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('FEED'),
        automaticallyImplyLeading: false,
        actions: <Widget>[

        ],
      ),
      bottomNavigationBar: BottomBar(
        items: [
          BarItem(icon: Icon(Icons.home), onPressed: () => goTo( FeedScreen.id ), couleur: Colors.blue),
          BarItem(icon: Icon(Icons.supervised_user_circle), onPressed: () => goTo( UsersList.id ), couleur: Colors.grey[500]),
          Container(width: 0.0, height: 0.0,),
          BarItem(icon: Icon(Icons.add_alert), onPressed: () => goTo( NotifScreen.id ), couleur: Colors.grey[500]),
          BarItem(icon: Icon(Icons.account_circle), onPressed: () => goTo( ProfileScreen.id ), couleur: Colors.grey[500]),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => BottomNav(uid: widget.uid).showModalSheet(context), child: Icon(Icons.add), backgroundColor: Colors.blue,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            Post post = posts[index];
            User user = users.singleWhere((u) => u.uid == post.uid);

            var date = DateTime.fromMillisecondsSinceEpoch(post.date);
            var formattedDate = formatDate(date, [dd, '/', mm, '/', yyyy]);
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: InkWell(
                child: Card(
                  elevation: 4.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.imageUrl != '' ? CachedNetworkImageProvider(user.imageUrl) : logoImage,
                          ),
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            post.titre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),
                          trailing: Text(
                            formattedDate,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      Image(
                        image: CachedNetworkImageProvider(post.imageUrl),
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(icon: (post.likes.contains(me.uid) ? Icon(Icons.favorite, color: Colors.redAccent,) : Icon(Icons.favorite_border)), onPressed: (){
                                postadd.Post().addlike(post, me);
                                post.uid == me.uid ? null : Notifs().addPost(post.uid, '${me.surname} a aimé votre photo', me.uid);
                              }),
                              Text(post.likes.length.toString()),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: <Widget>[
                                IconButton(icon: Icon(Icons.message), onPressed: () => BottomComments(id: post.documentID, comments: post.comments, uid: me.uid).showModalSheet(context)),
                                Text(post.comments.length.toString()),
                              ],
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
                onTap: (){
                  print(user.imageUrl);
                },
              ),
            );
          }
      ),
    );
  }
}
