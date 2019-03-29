import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileSliver extends StatefulWidget {
  final int index;

  const ProfileSliver({Key key, @required this.index}) : super(key: key);

  @override
  _ProfileSliverState createState() => _ProfileSliverState();
}

class _ProfileSliverState extends State<ProfileSliver> {
  ProfileTabMode _profileTabMode = ProfileTabMode.Timeline;

  int get _index => widget.index;

  Widget _buildBackgroundImage() {
    return Hero(
      tag: _index,
      child: Container(
        width: double.infinity,
        child: Image.asset(
          'assets/images/temp$_index.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(width: 2.0, color: Colors.grey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Image.asset('assets/images/temp3.jpg', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildFavoriteToggle() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            print('Favorite');
          },
        ),
        Text(
          '10k',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 20.0,
          ),
        )
      ],
    );
  }

  Widget _buildProfileSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 80.0,
      child: Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Row(
          children: <Widget>[
            _buildProfileImage(),
            SizedBox(width: 20.0),
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
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 5.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                ),
                child: _buildFavoriteToggle()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageStack() {
    return Stack(
      children: <Widget>[
        _buildBackgroundImage(),
        _buildProfileSynopsis(),
      ],
    );
  }

  Widget _buildTabItem(
      {@required ProfileTabMode profileTabMode,
      @required String tabTitle,
      @required IconData iconData}) {
    final Color tabButtonColor = Theme.of(context).backgroundColor;
    final TextStyle tabLabelTheme = TextStyle(color: tabButtonColor);

    final Color tabSelectedIconColor = Theme.of(context).accentColor;
    final TextStyle tabSelectedLabelTheme =
        TextStyle(color: Theme.of(context).accentColor);

    return InkWell(
      onTap: () {
        setState(() {
          _profileTabMode = profileTabMode;
        });
      },
      child: Container(
        height: 80.0,
        width: 100.0,
        decoration: BoxDecoration(
            color: _profileTabMode == profileTabMode
                ? tabButtonColor
                : Colors.transparent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData,
                size: _profileTabMode == profileTabMode ? 50.0 : 40.0,
                color: _profileTabMode == profileTabMode
                    ? tabSelectedIconColor
                    : tabButtonColor),
            Text(
              '$tabTitle',
              style: _profileTabMode == profileTabMode
                  ? tabSelectedLabelTheme
                  : tabLabelTheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 80.0,
      width: _screenWidth,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTabItem(
              profileTabMode: ProfileTabMode.Timeline,
              tabTitle: 'Timeline',
              iconData: Icons.timeline),
          _buildTabItem(
              profileTabMode: ProfileTabMode.Gallery,
              tabTitle: 'Gallery',
              iconData: Icons.image),
          _buildTabItem(
              profileTabMode: ProfileTabMode.Profile,
              tabTitle: 'Profile',
              iconData: Icons.person),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 300.0,
          flexibleSpace: _buildProfileImageStack(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(150.0),
            child: _buildTabs(),
          ),
        ),
        SliverToBoxAdapter(
          child: Posts(
            index: _index,
          ),
        )
      ],
    );
  }
}
