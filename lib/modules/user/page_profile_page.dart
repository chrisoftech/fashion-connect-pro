import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PageProfilePage extends StatefulWidget {
   final int index;

  const PageProfilePage({Key key, @required this.index}) : super(key: key);

  @override
  _PageProfilePageState createState() => _PageProfilePageState();
}

class _PageProfilePageState extends State<PageProfilePage> {
  int get _index => widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageProfile(index: _index),
    );
  }
}
