import 'package:flutter/material.dart';
import 'package:watch_news/services/auth.dart';

import 'feed.dart';

class RegisterScreen extends StatefulWidget {

  static String id = 'register';

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {

  String email;
  String password;
  String nom;
  String pseudo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your email',
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
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your password',
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
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                nom = value;
              },
              decoration: InputDecoration(
                hintText: 'Nom',
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
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                pseudo = value;
              },
              decoration: InputDecoration(
                hintText: 'Pseudo',
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
            MaterialButton(
              onPressed: () async {
                setState(() {
                });
                try {
                  FireHelper().createAccount(email, password, nom, pseudo);
                    //Navigator.pushNamed(context, ChatScreen.id);
                  setState(() {
                  });
                } catch(e) {
                  setState(() {
                  });
                  Navigator.pushNamed(context, FeedScreen.id);
                }
              },
              minWidth: 200.0,
              height: 42.0,
              color: Colors.orange,
              child: Text('Connnexion'),
            ),
          ],
        ),
      ),
    );
  }
}