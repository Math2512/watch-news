import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/models/post.dart';
import 'package:watch_news/my_widgets/constant.dart';
import 'package:watch_news/screens/notifications.dart';
import 'package:watch_news/screens/usersList.dart';
import 'package:watch_news/services/auth.dart';
import 'package:watch_news/services/bottomModal.dart';
import 'package:watch_news/services/post.dart' as ServicePost;
import 'package:image_picker/image_picker.dart';

import '../my_material.dart';
import 'feed.dart';

class ProfileScreen extends StatefulWidget {

  String uid;
  ProfileScreen(this.uid);


  static String id = 'profile';

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  StreamSubscription streamListener;
  int index = 0;
  int countPost;
  List<DocumentSnapshot> photo;
  List<Post> post  = [];
  List<User> users  = [];
  String surname;
  String desc;

  void goTo(String idScreen){
    Navigator.pushNamed(context, idScreen);
  }

  List<Post> getPost(List<DocumentSnapshot> postDocs) {
    List<Post> myList = post;

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

  Future<void>takePicture(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source, maxHeight: 500.0, maxWidth:500.0);
    FireHelper().modifyPicture(file);
  }

  @override
  void initState() {
    super.initState();

    streamListener = FireHelper().fireUser.document(widget.uid).snapshots().listen((document) {
      setState(() {
        me = User(document);
      });
    });

    streamListener = FireHelper().fireUser.snapshots().listen((datas) {
      getUsers(datas.documents);
      datas.documents.forEach((docs) {
        docs.reference.collection("posts").where(keyUid, isEqualTo: me.uid).snapshots().listen((posts) {
          var postDocs = posts.documents;
          setState(() {
            post = getPost(postDocs);
            countPost = post.length;
          });
        });
      });
    });

  }

  void showSimpleCustomDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                surname = value;
              },
              decoration: InputDecoration(
                hintText: me.surname,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:   BorderSide(color: Colors.white, width: 2.0),
                ),
              ),
            ),
            TextField(
              maxLines: 6,
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                desc = value;
              },
              decoration: InputDecoration(
                hintText: me.description != null ? me.description : 'Ajouter une description',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:   BorderSide(color: Colors.white, width: 2.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      Map<String, dynamic> data = {};
                      if(surname != null && surname != "")
                        data[keySurname] = surname;
                      if(desc != null && desc != "")
                        data[keyDescription] = desc;
                      FireHelper().modifyUser(data);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Valider',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Annuler',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }




  @override
  void dispose() {
    streamListener.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app, color: Colors.blue), onPressed: () => FireHelper().logOut()),
        ],
      ),
      bottomNavigationBar: BottomBar(
        items: [
          BarItem(icon: Icon(Icons.home), onPressed: () => goTo( FeedScreen.id ), couleur: Colors.grey[500]),
          BarItem(icon: Icon(Icons.supervised_user_circle), onPressed: () => goTo( UsersList.id ), couleur: Colors.grey[500]),
          Container(width: 0.0, height: 0.0,),
          BarItem(icon: Icon(Icons.add_alert), onPressed: () => goTo( NotifScreen.id ), couleur: Colors.grey[500]),
          BarItem(icon: Icon(Icons.account_circle), onPressed: () => goTo( ProfileScreen.id ), couleur: Colors.blue),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => BottomNav().showModalSheet(context), child: Icon(Icons.add), backgroundColor: Colors.blue,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60.0,
                backgroundImage: me.imageUrl != '' ? CachedNetworkImageProvider(me.imageUrl) : logoImage,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    me.surname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  IconButton(icon: Icon(Icons.edit), onPressed: () => showSimpleCustomDialog(context))
                ],
              ),
              SizedBox(height: 3),
              Text(
                me.description != null ? me.description : "Status should be here",
                style: TextStyle(
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.camera_enhance,
                      color: Colors.white,
                    ),
                    color: Colors.blue,
                    onPressed: (){
                      takePicture(ImageSource.camera);
                    },
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    child: Icon(
                      Icons.library_add,
                      color: Colors.white,
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: (){
                      takePicture(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              IconAdd(index: countPost),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FireHelper().postsFrom(widget.uid),
                builder: (context, snapshot){
                  if (snapshot.hasData) {
                    photo = snapshot.data.documents;
                    index = photo.length;
                    if (index > 0) {
                      return GridView.builder(
                        physics: ScrollPhysics(),
                        itemCount: index,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 200 / 200,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Image(
                              image: CachedNetworkImageProvider(photo[index].data['imageUrl']),
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    };
                  }else{
                    return Container();
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class IconAdd extends StatelessWidget {
  int index;
  IconAdd({this.index});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                index.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Posts",
                style: TextStyle(
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                (me.followers.length - 1).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Friends",
                style: TextStyle(
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

