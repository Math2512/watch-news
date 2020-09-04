
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/models/users.dart';
import 'package:watch_news/services/auth.dart';
import 'package:watch_news/services/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../my_material.dart';

class BottomNav{
  String uid;
  BottomNav({this.uid});
  String selected = '';
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
        child: MyDropdownButton(uid: uid,),
        padding: EdgeInsets.all(40.0),
      );
    });
  }
}

class MyDropdownButton extends StatefulWidget {

  String uid;
  MyDropdownButton({this.uid});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  StreamSubscription streamListener;
  String uid;
  String _selected;
  String _imageLink;





  @override
  void initState() {
    super.initState();
    streamListener = FireHelper().fireUser.document(widget.uid).snapshots().listen((document) {
      setState(() {
        me = User(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Ajouter un article'),
        Padding(
          padding: EdgeInsets.only(
              top: 10.0,
              left: 0.0,
              right: 0.0,
              bottom: 10.0
          ),
          child: Container(width: MediaQuery.of(context).size.width, height: 1.0, color: Colors.black,),
        ),
        TextField(
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Link',
              hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            setState(() {
              _imageLink = value;
            });
          },
        ),
          DropdownButton<String>(
          items: [
          DropdownMenuItem<String>(
          child: Text('Item 1'),
          value: 'one',
          ),
          DropdownMenuItem<String>(
          child: Text('Item 2'),
          value: 'two',
          ),
          DropdownMenuItem<String>(
          child: Text('Item 3'),
          value: 'three',
          ),
          ],
          onChanged: (value) {
            setState(() {
              _selected = value;
            });
          },
          hint: Text('Select Item'),
          value: _selected,
          ),
        TextField(
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Titre',
              hintStyle: TextStyle(color: Colors.grey)
          ),
          onChanged: (value) {

          },
        ),
        MaterialButton(
          onPressed: (){
            getArticle();
          },
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: Text('Valider', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  sendToFirebase(String title, String image, String url){
    Post().addPost(me.uid, title, image, url);
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
  }

  getArticle() async {

    final ArticleResponse = await http.get(
        'http://api.linkpreview.net/?key=${apiKey}&q=${_imageLink}');
    final profile = json.decode(ArticleResponse.body);

    sendToFirebase(profile['title'], profile['image'], profile['url']);
  }

}
