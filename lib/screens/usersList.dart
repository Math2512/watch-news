
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/my_widgets/barBottom.dart';
import 'package:watch_news/my_widgets/bottomNav.dart';
import 'package:watch_news/my_widgets/constant.dart';
import 'package:watch_news/screens/feed.dart';
import 'package:watch_news/screens/notifications.dart';
import 'package:watch_news/screens/profile.dart';
import 'package:watch_news/services/auth.dart';
import 'package:watch_news/services/bottomModal.dart';
import 'package:watch_news/services/notifs.dart';

class UsersList extends StatefulWidget {

  String uid;
  UsersList(this.uid);

  static String id = 'liste';

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

  StreamSubscription sub;
  List<User> users = [];
  int index = 0;
  bool is_accept = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupSub();
  }

  setupSub() {
    sub = FireHelper().fireUser.snapshots().listen((datas) {
      getUsers(datas.documents);
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

  void goTo(String idScreen){
    Navigator.pushNamed(context, idScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Utilisateurs'),
          automaticallyImplyLeading: false,
          actions: <Widget>[

          ],
          ),
        bottomNavigationBar: BottomBar(
          items: [
            BarItem(icon: Icon(Icons.home), onPressed: () => goTo( FeedScreen.id ), couleur: Colors.grey[500]),
            BarItem(icon: Icon(Icons.supervised_user_circle), onPressed: () => goTo( UsersList.id ), couleur: Colors.blue),
            Container(width: 0.0, height: 0.0,),
            BarItem(icon: Icon(Icons.add_alert), onPressed: () => goTo( NotifScreen.id ), couleur: Colors.grey[500]),
            BarItem(icon: Icon(Icons.account_circle), onPressed: () => goTo( ProfileScreen.id ), couleur: Colors.grey[500]),
          ],
        ),
      floatingActionButton: FloatingActionButton(onPressed: () => BottomNav().showModalSheet(context), child: Icon(Icons.add), backgroundColor: Colors.blue,),
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
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            User user = users[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.imageUrl != '' ? CachedNetworkImageProvider(user.imageUrl) : logoImage,
                ),

                contentPadding: EdgeInsets.all(0),
                title: Text(user.surname, style: TextStyle(color: Colors.black),),
                subtitle: Text(user.name),
                trailing: me.following.contains(user.uid) || me.uid == user.uid
                    ? FlatButton(
                  child: Text(
                    "Unfollow",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.grey,
                  onPressed: (){
                    FireHelper().addFollow(user);
                    me.uid == user.uid ? null : Notifs().addPost(user.uid, '${me.surname} a arrété de vous suivre', me.uid);
                  },
                ):FlatButton(
                  child: Text(
                    "Follow",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: (){
                    FireHelper().addFollow(user);
                    Notifs().addPost(user.uid, '${me.surname} a commencé à vous suivre', me.uid);
                  },
                ),
                onTap: (){},
              ),
            );
          },
        ),
    );
  }
}
