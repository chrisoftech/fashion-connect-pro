import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';

class PostForm extends StatefulWidget {
  final Profile profile;

  const PostForm({Key key, @required this.profile}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  Profile get _profile => widget.profile;

  List<Asset> _images = List<Asset>();
  String _error;

  bool _isProductAvail = false;

  Future<void> _loadAssets() async {
    // _scaffoldKey.currentState.hideCurrentSnackBar();

    setState(() {
      _images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  Widget _buildPostDialogActionControl() {
    return Positioned(
      top: 0.0,
      right: 20.0,
      child: Container(
        alignment: Alignment.center,
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
                Icons.add_a_photo,
                color: Theme.of(context).accentColor,
                size: 30.0,
              ),
              onPressed: _loadAssets,
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).errorColor,
                size: 30.0,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(_images.length, (index) {
        return AssetView(index, _images[index]);
      }),
    );
  }

  Widget _buildPostImages() {
    if (_images.length < 1) {
      return Container(
        width: double.infinity,
        child: Image.asset(
          'assets/avatars/bg-avatar.png',
          fit: BoxFit.cover,
        ),
      );
    } else {
      return _buildGridView();
    }
    // return Container(
    //   width: double.infinity,
    //   child: Image.asset(
    //     'assets/images/temp3.jpg',
    //     fit: BoxFit.cover,
    //   ),
    // );
  }

  Widget _buildPostProfileImage() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/profile');
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(width: 2.0, color: Colors.grey),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: _profile.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${_profile.imageUrl}',
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                )
              : Image.asset('assets/avatars/ps-avatar.png', fit: BoxFit.cover),
        ),
      ),
    );
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
        ],
      ),
    );
  }

  Widget _buildPostFormImagesStack() {
    return Stack(
      children: <Widget>[_buildPostImages(), _buildPostDialogActionControl()],
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
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: 600.0,
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
      ),
    );
  }
}
