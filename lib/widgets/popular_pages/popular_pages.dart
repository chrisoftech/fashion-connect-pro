import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularPages extends StatefulWidget {
  final ProfileBloc profileBloc;

  const PopularPages({Key key, @required this.profileBloc}) : super(key: key);

  @override
  _PopularPagesState createState() => _PopularPagesState();
}

class _PopularPagesState extends State<PopularPages> {
  ProfileBloc get _profileBloc => widget.profileBloc;

  @override
  void initState() {
    _profileBloc.onFetchProfiles();
    super.initState();
  }

  Widget _buildPageImage({@required Profile profile}) {
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
          child: Container(
            height: 90.0,
            width: 90.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45.0),
              border: Border.all(width: 2.0, color: Colors.white),
            ),
            child: profile.page.pageImageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(45.0),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/loader/loader.gif'),
                      image: NetworkImage('${profile.page.pageImageUrl}'),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(45.0),
                    child: Image.asset('assets/avatars/bg-avatar.png',
                        fit: BoxFit.cover),
                  ),
          ),
        )
      ],
    );
  }

  Widget _buildPageTitleRow({@required Profile profile}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('${profile.page.pageTitle}',
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

  Widget _buildPageDescription({@required Profile profile}) {
    final String description = '${profile.page.pageDescription}';

    return Text(
      description.length > 50
          ? '${description.substring(0, 50)}...'
          : '$description',
      softWrap: true,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPopularPageItem({@required Profile profile}) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _contentWidth = _screenWidth > 400.0 ? 450.0 : _screenWidth;

    final _pageDescriptionContentWidth = _contentWidth - 140.0;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    PageProfilePage(profile: profile)));
      },
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              height: 130.0,
              width: _contentWidth,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildPageImage(profile: profile),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Container(
                      width: _pageDescriptionContentWidth,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildPageTitleRow(profile: profile),
                          SizedBox(height: 20.0),
                          _buildPageDescription(profile: profile),
                          SizedBox(height: 10.0),
                          Row(
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
                        ],
                      ),
                    ),
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
    final double _contentHeight = _screenHeight - 190.0;

    return BlocBuilder<ProfileEvent, ProfileState>(
      bloc: _profileBloc,
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileUninitialized) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ProfileError) {
          return Center(child: Text('Failed to load pages :('));
        }

        if (state is ProfilesLoaded) {
          if (state.profiles.isEmpty) {
            return Center(child: Text('No pages found :('));
          }

          return Container(
            height: _contentHeight,
            child: ListView.builder(
              itemCount: state.profiles.length,
              itemBuilder: (BuildContext context, int index) {
                final Profile profile = state.profiles[index];

                return _buildPopularPageItem(profile: profile);
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
