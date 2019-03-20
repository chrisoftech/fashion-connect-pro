import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileForm(),
    );
  }
}
