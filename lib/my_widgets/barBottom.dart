import 'package:flutter/material.dart';

class BarItem extends IconButton {
  BarItem({@required Icon icon, @required VoidCallback onPressed, @required Color couleur}) : super (
      icon:icon,
      onPressed:onPressed,
      color: couleur
  );
}