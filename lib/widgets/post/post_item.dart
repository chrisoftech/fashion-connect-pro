import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostItem extends StatefulWidget {
  final PostUser postUser;

  const PostItem({Key key, @required this.postUser}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  int _currentPostImageIndex = 0;

  PostUser get _postUser => widget.postUser;

  @override
  Widget build(BuildContext context) {
    Widget _buildActivePostImage() {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Color.fromRGBO(0, 0, 0, 0.9)));
    }

    Widget _buildInactivePostImage() {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Color.fromRGBO(0, 0, 0, 0.4)));
    }

    Widget _buildPostImageCarouselIndicator() {
      List<Widget> dots = [];

      for (int i = 0; i < _postUser.post.postImageUrls.length; i++) {
        dots.add(i == _currentPostImageIndex
            ? _buildActivePostImage()
            : _buildInactivePostImage());
      }

      return Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 130.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: dots,
          ));
    }

    Widget _buildPostImageCarousel() {
      return CarouselSlider(
          height: 400.0,
          viewportFraction: _postUser.post.postImageUrls.length > 1 ? 0.8 : 1.0,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          onPageChanged: (int index) {
            setState(() {
              _currentPostImageIndex = index;
            });
          },
          items: _postUser.post.postImageUrls.map((postImageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(
                    _postUser.post.postImageUrls.length > 1 ? 10.0 : 0.0,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: '$postImageUrl',
                    placeholder: (context, url) =>
                        Center(child: new CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Center(child: new Icon(Icons.error)),
                  ),
                );
              },
            );
          }).toList());
    }

    Widget _buildPostCardBackgroundImage() {
      return Container(
        child: _postUser.post.postImageUrls.length > 0
            ? _buildPostImageCarousel()
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
          Expanded(child: Text('${_postUser.post.title}')),
          Text(
            'c${_postUser.post.price}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    Widget _buildPostDecription() {
      return Row(
        children: <Widget>[
          Expanded(child: Text('${_postUser.post.description}')),
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
                    leading: Container(
                      height: 50.0,
                      width: 50.0,
                      child: _postUser.userProfile.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: '${_postUser.userProfile.imageUrl}',
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Image.asset('assets/avatars/ps-avatar.png',
                                  fit: BoxFit.cover),
                            ),
                    ),
                    title: Text(
                        '${_postUser.userProfile.firstname} ${_postUser.userProfile.lastname}'),
                    subtitle: Text('${_postUser.post.lastUpdate}'),
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
                      _postUser.post.postImageUrls.length > 1
                          ? _buildPostImageCarouselIndicator()
                          : Container(),
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
