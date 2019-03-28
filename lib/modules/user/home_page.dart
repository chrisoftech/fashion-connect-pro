import 'package:fashion_connect/blocs/page_bloc.dart';
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
  PageBloc _pageBloc;
  bool _isProductAvail = false;

  @override
  void initState() {
    _pageBloc = PageBloc();
    super.initState();
  }

  @override
  void dispose() {
    _pageBloc.dispose();
    super.dispose();
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

  Widget _buildPostDialogCloseControl() {
    return Positioned(
      top: 0.0,
      right: 20.0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
        ),
        child: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).errorColor,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            print('Close dialog');
          },
        ),
      ),
    );
  }

  Widget _buildPostImages() {
    return Container(
      width: double.infinity,
      child: Image.asset(
        'assets/images/temp3.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPostProfileImage() {
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

  Widget _buildPostFormImageControl() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0)),
        ),
        child: IconButton(
          icon: Icon(
            Icons.add_a_photo,
            color: Theme.of(context).accentColor,
            size: 30.0,
          ),
          onPressed: () {
            print('Add image');
          },
        ));
  }

  Widget _buildPostSynopsis() {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: _screenWidth,
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
          _buildPostProfileImage(),
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
              child: _buildPostFormImageControl()),
        ],
      ),
    );
  }

  Widget _buildPostFormImagesStack() {
    return Stack(
      children: <Widget>[_buildPostImages(), _buildPostDialogCloseControl()],
    );
  }

  Widget _buildPostFormControl() {
    return Expanded(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 40.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Text('Post Product',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildPostFormInput() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        print('tapped');
      },
      child: Container(
        height: 400.0,
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: 'Post title',
                  filled: true,
                  border: InputBorder.none),
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  border: InputBorder.none),
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Price', filled: true, border: InputBorder.none),
            ),
            SizedBox(height: 20.0),
            SwitchListTile.adaptive(
              value: _isProductAvail,
              activeColor: Theme.of(context).accentColor,
              title: Text('Is this product available?'),
              onChanged: (bool value) {
                setState(() {
                  _isProductAvail = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            _buildPostFormControl()
          ],
        ),
      ),
    );
  }

  void _buildPostDialogBox() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 1000.0,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    expandedHeight: 200.0,
                    flexibleSpace: _buildPostFormImagesStack(),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(30.0),
                      child: _buildPostSynopsis(),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildPostFormInput())
                ],
              ),
            ),
          );
        });
  }

  void _buildPostBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 1000.0,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: 200.0,
                  flexibleSpace: _buildPostFormImagesStack(),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(30.0),
                    child: _buildPostSynopsis(),
                  ),
                ),
                SliverToBoxAdapter(child: _buildPostFormInput())
              ],
            ),
          );
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
      // onPressed: _buildPostBottomSheet,
      onPressed: _buildPostDialogBox,
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
              // actions: <Widget>[
              //   _buildPostDialogCloseControl()
              // ],
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
                        title: 'Recent Posts',
                        action: SectionLabelAction.Timeline),
                    RecentPosts(),
                    SizedBox(height: 10.0),
                    _buildSectionLabel(
                        title: 'Popular Pages',
                        action: SectionLabelAction.PopularPages),
                    PopularPages(pageBloc: _pageBloc),
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
