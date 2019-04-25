import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSliver extends StatefulWidget {
  final Profile profile;
  final Function fetchProfile;

  const ProfileSliver({Key key, @required this.profile, this.fetchProfile})
      : super(key: key);

  @override
  _ProfileSliverState createState() => _ProfileSliverState();
}

class _ProfileSliverState extends State<ProfileSliver> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProfileTabMode _profileTabMode = ProfileTabMode.Timeline;

  Function get _fetchProfile => widget.fetchProfile;
  Profile get _profile => widget.profile;

  Widget _buildBackgroundImage() {
    return InkWell(
      onTap: () {
        _openSelectImageDialog(
            imageUrl: _profile.page.pageImageUrl.isNotEmpty
                ? '${_profile.page.pageImageUrl}'
                : '',
            profileImageSelectMode: ProfileImageSelectMode.PageImage);
      },
      child: Container(
        // height: 250.0,
        width: double.infinity,
        child: _profile.page.pageImageUrl.isNotEmpty
            ? FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/avatars/bg-avatar.png'),
                image: NetworkImage('${_profile.page.pageImageUrl}'),
              )
            : Image.asset('assets/avatars/bg-avatar.png', fit: BoxFit.cover),
      ),
    );
  }

  void _openSelectImageDialog(
      {@required String imageUrl,
      @required ProfileImageSelectMode profileImageSelectMode}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProfileImageDialog(
              imageUrl: imageUrl,
              profile: _profile,
              scaffoldKey: _scaffoldKey,
              profileImageSelectMode: profileImageSelectMode);
        }).then((_) => _fetchProfile());
  }

  Widget _buildProfileImage() {
    return InkWell(
      onTap: () {
        _openSelectImageDialog(
            imageUrl: _profile.imageUrl.isNotEmpty ? _profile.imageUrl : '',
            profileImageSelectMode: ProfileImageSelectMode.UserImage);
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(width: 2.0, color: Colors.white),
        ),
        child: _profile.imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(45.0),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/loader/loader.gif'),
                  image: NetworkImage('${_profile.imageUrl}'),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset('assets/avatars/ps-avatar.png',
                    fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _buildSliverAction() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)),
      ),
      child: Row(
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
      ),
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
                    '${_profile.page.pageTitle}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    '${_profile.page.pageDescription}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
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
    return GestureDetector(
      onTap: () {
        _scaffoldKey.currentState.hideCurrentSnackBar();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              actions: <Widget>[_buildSliverAction()],
              flexibleSpace: _buildProfileImageStack(),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(150.0),
                child: _buildTabs(),
              ),
            ),
            SliverToBoxAdapter(
              child: Posts(),
            )
          ],
        ),
      ),
    );
  }
}
