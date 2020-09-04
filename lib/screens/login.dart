import 'package:flutter/material.dart';
import 'package:watch_news/screens/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watch_news/screens/profile.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'login';

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
            MaterialButton(
              onPressed: () async {
                setState(() {
                });
                try {
                  final newUser = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser != null){
                    Navigator.pushNamed(context, FeedScreen.id);
                  }
                  setState(() {
                  });
                } catch(e) {
                  print(e);
                  setState(() {
                  });
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
