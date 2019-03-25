import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildAppBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'fashion',
          style: TextStyle(
              color: Theme.of(context).cardColor,
              fontStyle: FontStyle.italic,
              fontSize: 25.0,
              fontWeight: FontWeight.w700),
        ),
        Text('connect',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontStyle: FontStyle.italic,
                fontSize: 25.0,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildSearchInput() {
    return Container(
      height: 160.0,
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'How can we help you today?',
            style: TextStyle(
                color: Theme.of(context).backgroundColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          TextField(
            style: TextStyle(fontSize: 20.0),
            decoration: InputDecoration(
                labelText: 'Search for posts',
                filled: true,
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
                border: InputBorder.none),
          )
        ],
      ),
    );
  }

  Widget _buildPost() {
    return Card(
      child: Container(
        height: 200.0,
        width: 250.0,
        child: Column(
          children: <Widget>[],
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
              _buildPost(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPopularPageItem() {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _contentWidth = _screenWidth > 400.0 ? 450.0 : _screenWidth;

    return Column(
      children: <Widget>[
        Card(
          child: Container(
            height: 150.0,
            width: _contentWidth,
            child: Column(
              children: <Widget>[],
            ),
          ),
        ),
        SizedBox(height: 10.0)
      ],
    );
  }

  Widget _buildPopularPages() {
    final double _screenHeight = MediaQuery.of(context).size.height;
    // final double _contentHeight = _screenHeight - 350.0;
    final double _contentHeight = _screenHeight - 300.0;

    return Container(
      height: _contentHeight,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return _buildPopularPageItem();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              pinned: true,
              floating: true,
              centerTitle: true,
              expandedHeight: 0.0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(160.0),
                child: _buildSearchInput(),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Recent posts',
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    _buildRecentPosts(),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Popular pages',
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Show All',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20.0),
                            ),
                          ),
                        )
                      ],
                    ),
                    _buildPopularPages(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
