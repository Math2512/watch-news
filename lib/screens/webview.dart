import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';

class Webview extends StatefulWidget {

  String url;
  String title;
  Webview({this.url, this.title});

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        ),
        body: WebviewScaffold(
          url: widget.url,
        )
    );
  }
}
