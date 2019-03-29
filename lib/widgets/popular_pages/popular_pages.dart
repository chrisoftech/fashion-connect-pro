import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularPages extends StatefulWidget {
  final PageBloc pageBloc;

  const PopularPages({Key key, @required this.pageBloc}) : super(key: key);

  @override
  _PopularPagesState createState() => _PopularPagesState();
}

class _PopularPagesState extends State<PopularPages> {
  PageBloc get _pageBloc => widget.pageBloc;

  @override
  void initState() {
    _pageBloc.onFetchPages();
    super.initState();
  }

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
          child: Hero(
            tag: index,
            child: CircleAvatar(
              radius: 45.0,
              backgroundImage: AssetImage('assets/images/temp$index.jpg'),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPageTitleRow({@required Page page}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('${page.pageTitle}',
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

  Widget _buildPageDescription({@required Page page}) {
    final String description = '${page.pageDescription}';

    return Text(
      description.length > 50
          ? '${description.substring(0, 50)}...'
          : '$description',
      softWrap: true,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPopularPageItem({@required Page page}) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _contentWidth = _screenWidth > 400.0 ? 450.0 : _screenWidth;

    final _pageDescriptionContentWidth = _contentWidth - 220.0;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PageProfilePage()));
      },
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              height: 150.0,
              width: _contentWidth,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: _buildPageImage(index: 3),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    children: <Widget>[
                      Container(
                        width: _pageDescriptionContentWidth,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: _buildPageTitleRow(page: page),
                      ),
                      Container(
                        width: _pageDescriptionContentWidth,
                        child: _buildPageDescription(page: page),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _contentHeight = _screenHeight - 250.0;

    return BlocBuilder<PageEvent, PageState>(
      bloc: _pageBloc,
      builder: (BuildContext context, PageState state) {
        if (state is PageUnitialized) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is PageError) {
          return Center(child: Text('Faild to load pages :('));
        }

        if (state is PageLoaded) {
          if (state.pages.isEmpty) {
            return Center(child: Text('No pages found :('));
          }

          return Container(
            height: _contentHeight,
            child: ListView.builder(
              itemCount: state.pages.length,
              itemBuilder: (BuildContext context, int index) {
                final Page page = state.pages[index];

                return _buildPopularPageItem(page: page);
              },
            ),
          );
        }
      },
    );
  }
}
