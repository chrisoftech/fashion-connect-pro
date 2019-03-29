import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PageProfilePage extends StatefulWidget {
  @override
  _PageProfilePageState createState() => _PageProfilePageState();
}

class _PageProfilePageState extends State<PageProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileSliver(profileMode: ProfileMode.Page,),
    );
  }
}
