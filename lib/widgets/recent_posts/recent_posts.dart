import 'package:flutter/material.dart';

class RecentPosts extends StatelessWidget {
  Widget _buildPostBackgroundImage({@required int index}) {
    return Container(
        height: 200.0,
        width: 250.0,
        child: Image.asset('assets/images/temp$index.jpg', fit: BoxFit.cover));
  }

  Widget _buildProfileSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Some Description',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPost({@required int index}) {
    return Card(
      child: Container(
        height: 200.0,
        width: 250.0,
        child: Stack(
          children: <Widget>[
            _buildPostBackgroundImage(index: index),
            _buildProfileSynopsis()
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPosts() {
    return Container(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              _buildPost(index: index),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRecentPosts();
  }
}
