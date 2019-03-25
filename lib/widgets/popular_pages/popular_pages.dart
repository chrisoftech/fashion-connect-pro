import 'package:flutter/material.dart';

class PopularPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildPageImage({@required int index}) {
      return Stack(
        children: <Widget>[
          Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(40.0))),
          Positioned(
            top: 5.0,
            left: 5.0,
            child: Container(
                height: 110.0,
                width: 110.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(55.0))),
          ),
          Positioned(
            top: 15.0,
            left: 15.0,
            child: CircleAvatar(
              radius: 45.0,
              backgroundImage: AssetImage('assets/images/temp$index.jpg'),
            ),
          )
        ],
      );
    }

    Widget _buildPageTitleRow() {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text('Page Title',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
          Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildPageDescription() {
      final String description = 'Page description will be displayed here!';

      return Text(
        description.length > 50
            ? '${description.substring(0, 50)}...'
            : '$description',
        softWrap: true,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }

    Widget _buildPopularPageItem({@required int index}) {
      final double _screenWidth = MediaQuery.of(context).size.width;
      final double _contentWidth = _screenWidth > 400.0 ? 450.0 : _screenWidth;

      final _pageDescriptionContentWidth = _contentWidth - 220.0;

      return Column(
        children: <Widget>[
          Card(
            child: Container(
              height: 150.0,
              width: _contentWidth,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: _buildPageImage(index: index),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    children: <Widget>[
                      Container(
                        width: _pageDescriptionContentWidth,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: _buildPageTitleRow(),
                      ),
                      Container(
                        width: _pageDescriptionContentWidth,
                        child: _buildPageDescription(),
                      ),
                      Container(
                        width: _pageDescriptionContentWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).backgroundColor,
                              size: 15.0,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              '1K',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0)
        ],
      );
    }

    Widget _buildPopularPages() {
      final double _screenHeight = MediaQuery.of(context).size.height;
      final double _contentHeight = _screenHeight - 250.0;

      return Container(
        height: _contentHeight,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return _buildPopularPageItem(index: index);
          },
        ),
      );
    }

    return _buildPopularPages();
  }
}
