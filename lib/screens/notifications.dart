import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/models/notifsModel.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/screens/profile.dart';
import 'package:watch_news/screens/usersList.dart';
import 'package:watch_news/services/auth.dart';
import 'package:watch_news/services/bottomModal.dart';
import 'package:date_format/date_format.dart';

import '../my_material.dart';
import 'feed.dart';

class NotifScreen extends StatefulWidget {
  String uid;
  NotifScreen({this.uid});

  static String id = 'notification';

  @override
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {

  StreamSubscription sub;
  List<Notif> notif = [];
  List<User> users = [];

  void goTo(String idScreen){
    Navigator.pushNamed(context, idScreen);
  }

  List<Notif> getNotif(List<DocumentSnapshot> postDocs) {
    List<Notif> myList = notif;

    postDocs.forEach((p) {
      Notif notif = Notif(p);
      if (myList.every((p) => p.documentID != notif.documentID)) {
        myList.add(notif);
      } else {
        Notif toBeChanged = myList.singleWhere((p) => p.documentID == notif.documentID);
        myList.remove(toBeChanged);
        myList.add(notif);
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

  setupSub() {
    sub = FireHelper().fireUser.snapshots().listen((datas) {
      getUsers(datas.documents);

      datas.documents.forEach((docs) {
        docs.reference.collection("notifications").where(keyUid, isEqualTo: me.uid).orderBy('date', descending:  true).snapshots().listen((post) {
          var postDocs = post.documents;
          setState(() {
            notif = getNotif(postDocs);
          });
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupSub();
  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        automaticallyImplyLeading: false,
        actions: <Widget>[

        ],
      ),
      bottomNavigationBar: BottomBar(
        items: [
          BarItem(icon: Icon(Icons.home), onPressed: () => goTo( FeedScreen.id ), couleur: Colors.grey[500]),
          BarItem(icon: Icon(Icons.supervised_user_circle), onPressed: () => goTo( UsersList.id ), couleur: Colors.grey[500]),
          Container(width: 0.0, height: 0.0,),
          BarItem(icon: Icon(Icons.add_alert), onPressed: () => goTo( NotifScreen.id ), couleur: Colors.blue),
          BarItem(icon: Icon(Icons.account_circle), onPressed: () => goTo( ProfileScreen.id ), couleur: Colors.grey[500]),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => BottomNav(uid: widget.uid).showModalSheet(context), child: Icon(Icons.add), backgroundColor: Colors.blue,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView.separated(
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: notif.length,
        itemBuilder: (BuildContext context, int index) {
          Notif notifs = notif[index];
          User user = users.singleWhere((u) => u.uid == notifs.userId);
          var date = DateTime.fromMillisecondsSinceEpoch(notifs.date);
          var formattedDate = formatDate(date, [dd, '/', mm, '/', yyyy, ' à ', HH,':', nn,':',ss]);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage: user.imageUrl != '' ? CachedNetworkImageProvider(user.imageUrl) : logoImage,
                ),

              contentPadding: EdgeInsets.all(0),
              title: Text(notifs.notification, style: TextStyle(color: Colors.black),),
              trailing: Text(
                formattedDate,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
              onTap: (){},
            ),
          );
        },

      ),
    );
  }
}
