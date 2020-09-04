import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_news/screens/feed.dart';
import 'package:watch_news/screens/home.dart';
import 'package:watch_news/screens/login.dart';
import 'package:watch_news/screens/notifications.dart';
import 'package:watch_news/screens/profile.dart';
import 'package:watch_news/screens/register.dart';
import 'package:watch_news/screens/usersList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        backgroundColor: Color(0xfffcfcff),
        primaryColor: Color(0xfffcfcff),
        accentColor: Colors.blue,
        scaffoldBackgroundColor: Color(0xfffcfcff),
        canvasColor: Colors.transparent,
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black,),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18.0
            )
          ),
        )
      ),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        FeedScreen.id: (context)=>_feed(),
        RegisterScreen.id: (context)=>RegisterScreen(),
        LoginScreen.id: (context)=>LoginScreen(),
        ProfileScreen.id: (context)=>_handleAuth(),
        UsersList.id: (context)=> _userList(),
        NotifScreen.id: (context)=> _notif(),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _feed() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        return (!snapshot.hasData || snapshot.data.uid == null ) ? HomeScreen() : FeedScreen(uid: snapshot.data.uid);
      },
    );
  }
  Widget _userList() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        return (!snapshot.hasData || snapshot.data.uid == '' ) ? HomeScreen() : UsersList(snapshot.data.uid);
      },
    );
  }

  Widget _handleAuth() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        return (!snapshot.hasData || snapshot.data.uid == null ) ? HomeScreen() : ProfileScreen(snapshot.data.uid);
      },
    );
  }

  Widget _notif() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        return (!snapshot.hasData || snapshot.data.uid == null ) ? HomeScreen() : NotifScreen(uid: snapshot.data.uid);
      },
    );
  }


}
