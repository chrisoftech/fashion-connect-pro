import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/utilities/utilities.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

enum SectionLabelAction {
  Timeline,
  PopularPages,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProfileBloc _profileBloc;
  ProfileRepository _profileRepository;

  PostFormBloc _postFormBloc;
  PostRepository _postRepository;

  Profile _profile;

  @override
  void initState() {
    _profileRepository = ProfileRepository();
    _profileBloc = ProfileBloc(profileRepository: _profileRepository);
    _profileBloc.onFetchProfile();

    _postRepository = PostRepository();
    _postFormBloc = PostFormBloc(postRepository: _postRepository);

    _fetchProfile();
    super.initState();
  }

  @override
  void dispose() {
    _profileBloc.dispose();
    _postFormBloc.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    _profile = await _profileRepository.getProfile;
  }

  Widget _buildSearchInput() {
    return Container(
      // height: 140.0,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'How can we help you today?',
            style: TextStyle(
                color: Theme.of(context).backgroundColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          TextField(
            style: TextStyle(fontSize: 20.0),
            decoration: InputDecoration(
                // labelText: 'Search for pages',
                hintText: 'Search for pages',
                filled: true,
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
                border: InputBorder.none),
          )
        ],
      ),
    );
  }

  Widget _buildSectionLabel(
      {@required String title, @required SectionLabelAction action}) {
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
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              action == SectionLabelAction.Timeline ? 'Timeline' : 'Show All',
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 20.0),
            ),
          ),
        )
      ],
    );
  }

  void _buildPostDialogModal() {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) {
    //           return PostForm(profile: _profile, postFormBloc: _postFormBloc);
    //         },
    //         fullscreenDialog: true));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _fetchProfile();
          return PostForm(profile: _profile, postFormBloc: _postFormBloc);
        });
  }

  Widget _buildPostFAB() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).cardColor,
      child: Icon(
        Icons.add_a_photo,
        size: 35.0,
        color: Theme.of(context).accentColor,
      ),
      // onPressed: _buildPostDialogBox,
      onPressed: _buildPostDialogModal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        drawer: SideDrawer(),
        floatingActionButton: _buildPostFAB(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              pinned: true,
              floating: true,
              centerTitle: true,
              expandedHeight: 0.0,
              bottom: PreferredSize(
                // preferredSize: Size.fromHeight(125.0),
                preferredSize: Size.fromHeight(105.0),
                child: _buildSearchInput(),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: <Widget>[
                    _buildSectionLabel(
                        title: 'Recent Posts',
                        action: SectionLabelAction.Timeline),
                    RecentPosts(),
                    SizedBox(height: 10.0),
                    _buildSectionLabel(
                        title: 'Popular Pages',
                        action: SectionLabelAction.PopularPages),
                    PopularPages(profileBloc: _profileBloc),
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
