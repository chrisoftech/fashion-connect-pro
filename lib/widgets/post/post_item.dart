import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final int index;
  final String post;

  const PostItem({Key key, @required this.index, @required this.post})
      : super(key: key);

  int get _index => index;
  String get _post => post;

  @override
  Widget build(BuildContext context) {
    Widget _buildPostCardBackgroundImage({@required String post}) {
      return Container(
        child: Image.asset(
          '$post',
          fit: BoxFit.cover,
        ),
      );
    }

    Widget _buildPostCardActions() {
      return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 70.0,
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ]),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      print('Chat');
                    },
                    splashColor: Theme.of(context).accentColor,
                    icon: Icon(
                      Icons.textsms,
                      size: 40.0,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Call');
                    },
                    splashColor: Theme.of(context).accentColor,
                    icon: Icon(
                      Icons.call,
                      size: 40.0,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildPostTitle() {
      return Row(
        children: <Widget>[
          Expanded(child: Text('Product title')),
          Text(
            'c10.0',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    Widget _buildPostDecription() {
      return Row(
        children: <Widget>[
          Expanded(
              child: Text('Product Description and other details i dont ...')),
          Icon(
            Icons.favorite_border,
            color: Theme.of(context).backgroundColor,
            size: 20.0,
          ),
          SizedBox(width: 5.0),
          Text(
            '10k',
            style: TextStyle(color: Theme.of(context).accentColor),
          )
        ],
      );
    }

    Widget _buildPostCardSynopsis() {
      return Positioned(
        right: 0.0,
        left: 0.0,
        bottom: 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: ListTile(
            title: _buildPostTitle(),
            subtitle: _buildPostDecription(),
          ),
        ),
      );
    }

    Widget _buildPostItem({@required String post}) {
      final _deviceWidth = MediaQuery.of(context).size.width;
      final _contentWidth = _deviceWidth > 400.0 ? 450.0 : _deviceWidth;

      return Column(
        children: <Widget>[
          Card(
            child: Container(
              width: _contentWidth,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/temp$_index.jpg')),
                    title: Text('John Doe'),
                    subtitle: Text('March 28, Thursday 2019'),
                    trailing: IconButton(
                      onPressed: () {
                        print('isFavorite');
                      },
                      icon: Icon(Icons.favorite, color: Colors.red),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      _buildPostCardBackgroundImage(post: post),
                      _buildPostCardActions(),
                      _buildPostCardSynopsis(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0)
        ],
      );
    }

    return _buildPostItem(post: _post);
  }
}
