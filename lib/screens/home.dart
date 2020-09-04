import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/screens/login.dart';
import 'package:watch_news/screens/profile.dart';
import 'package:watch_news/screens/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:watch_news/services/auth.dart';

import 'feed.dart';


class HomeScreen extends StatefulWidget {

  static String id = 'home';

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
              minWidth: 200.0,
              height: 42.0,
              color: Colors.orange,
              child: Text('Login'),
            ),
            MaterialButton(
              onPressed: (){
                Navigator.pushNamed(context, RegisterScreen.id);
              },
              minWidth: 200.0,
              height: 42.0,
              color: Colors.orange,
              child: Text('Register'),
            ),
            InkWell(
              onTap: ()async{
                final facebookLogin = FacebookLogin();
                final result = await facebookLogin.logIn(['public_profile', 'email']);
                if(result.status == FacebookLoginStatus.loggedIn ){
                FireHelper().fblogin(result.accessToken.token);
                Navigator.pushNamed(context, ProfileScreen.id);
                }
              },
              child: Container(
                width: 200.0,
                height: 42.0,
                color: Colors.blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.facebookF),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
              },
              child: Container(
                width: 200.0,
                height: 42.0,
                color: Colors.redAccent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.google),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

