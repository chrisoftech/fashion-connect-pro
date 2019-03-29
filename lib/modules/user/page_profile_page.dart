import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PageProfilePage extends StatefulWidget {
  final Profile profile;

  const PageProfilePage({Key key, @required this.profile}) : super(key: key);
  @override
  _PageProfilePageState createState() => _PageProfilePageState();
}

class _PageProfilePageState extends State<PageProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileSliver(profile: widget.profile),
    );
  }
}
