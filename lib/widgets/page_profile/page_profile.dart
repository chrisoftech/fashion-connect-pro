import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

enum ProfileTabMode { Timeline, Gallery, Profile }

class PageProfile extends StatefulWidget {
  final int index;

  const PageProfile({Key key, @required this.index}) : super(key: key);

  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  @override
  Widget build(BuildContext context) {
    return ProfileAppBar(index: widget.index);
  }
}
