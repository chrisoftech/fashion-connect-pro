import 'package:fashion_connect/utilities/utilities.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                labelText: 'Search for pages',
                filled: true,
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
                border: InputBorder.none),
          )
        ],
      ),
    );
  }

  Widget _buildSectionLabel({@required String title, bool showAction = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            '$title',
            style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 25.0,
                fontWeight: FontWeight.w900),
          ),
        ),
        !showAction
            ? Container()
            : InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Show All',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 20.0),
                  ),
                ),
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        drawer: SideDrawer(),
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
                    _buildSectionLabel(
                        title: 'Recent Posts', showAction: false),
                    RecentPosts(),
                    SizedBox(height: 10.0),
                    _buildSectionLabel(title: 'Popular Pages'),
                    PopularPages(),
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
