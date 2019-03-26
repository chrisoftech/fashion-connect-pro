import 'package:flutter/material.dart';

class DrawerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(60.0),
            child: Image.asset(
              'assets/images/temp4.jpg',
              fit: BoxFit.cover,
              height: 120.0,
              width: 120.0,
            )),
        SizedBox(height: 20.0),
        Text('example@gmail.com',
            style: TextStyle(
                // color: _textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold)),
        FlatButton(
          child: Text(
            'View Profile',
            style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
        Divider(height: 20.0),
      ],
    );
  }
}
