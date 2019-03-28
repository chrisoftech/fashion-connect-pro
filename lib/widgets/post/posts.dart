import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  final int index;

  const Posts({Key key, @required this.index}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  int get _index => widget.index;

  List<String> _demoPosts = [
    'assets/images/temp0.jpg',
    'assets/images/temp1.jpg',
    'assets/images/temp2.jpg',
    'assets/images/temp3.jpg',
    'assets/images/temp4.jpg',
    'assets/images/temp5.jpg',
    'assets/images/temp6.jpg',
    'assets/images/temp7.jpg',
    'assets/images/temp8.jpg',
    'assets/images/temp9.jpg',
  ];

  Widget _buildPagePosts() {
    return Column(
        children: _demoPosts.map((String post) {
      return PostItem(
        index: _index,
        post: post,
      );
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return _buildPagePosts();
  }
}
