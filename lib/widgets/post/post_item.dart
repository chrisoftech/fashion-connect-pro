import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({Key key, @required this.post}) : super(key: key);

  Post get _post => post;

  @override
  Widget build(BuildContext context) {
    Widget _buildPostCardBackgroundImage() {
      return Container(
        child: _post.postImageUrls.length > 0
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: '${_post.postImageUrls[0]}',
                placeholder: (context, url) =>
                    Center(child: new CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Center(child: new Icon(Icons.error)),
              )
            : Image.asset('assets/avatars/bg-avatar.png', fit: BoxFit.cover),
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
          Expanded(child: Text('${_post.title}')),
          Text(
            'c${_post.price}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    Widget _buildPostDecription() {
      return Row(
        children: <Widget>[
          Expanded(child: Text('${_post.description}')),
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

    Widget _buildPostItem() {
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
                        backgroundImage: AssetImage('assets/images/temp3.jpg')),
                    title: Text('${_post.uid}'),
                    subtitle: Text('${_post.lastUpdate}'),
                    trailing: IconButton(
                      onPressed: () {
                        print('isFavorite');
                      },
                      icon: Icon(Icons.favorite, color: Colors.red),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      _buildPostCardBackgroundImage(),
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

    return _buildPostItem();
  }
}
