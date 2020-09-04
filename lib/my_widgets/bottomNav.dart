import 'package:flutter/material.dart';
import 'package:watch_news/my_material.dart';

class BottomBar extends BottomAppBar {
  BottomBar({@required List<Widget> items}) : super(
    color: null,
    shape: CircularNotchedRectangle(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: items,
    ),
  );
}