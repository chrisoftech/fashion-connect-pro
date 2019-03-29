import 'package:fashion_connect/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';

class ProfileImageDialog extends StatefulWidget {
  final String imageUrl;
  final bool isProfileImage;

  const ProfileImageDialog(
      {Key key, @required this.imageUrl, @required this.isProfileImage})
      : super(key: key);

  @override
  _ProfileImageDialogState createState() => _ProfileImageDialogState();
}

class _ProfileImageDialogState extends State<ProfileImageDialog> {
  List<Asset> _images = List<Asset>();
  String _error;

  String get _imageUrl => widget.imageUrl ?? '';
  bool get _isProfileImage => widget.isProfileImage ?? false;

  Future<void> _loadAssets() async {
    setState(() {
      _images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
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

  Widget _buildPostDialogCloseControl() {
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

  Widget _buildPostImage() {
    return Container(
      width: double.infinity,
      child: _images.length > 0
          ? Column(
              children: <Widget>[Expanded(child: AssetView(0, _images[0]))],
            )
          : _imageUrl.isNotEmpty
              ? FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/loader/loader.gif'),
                  image: NetworkImage('$_imageUrl'),
                )
              : Image.asset(
                  'assets/avatars/avatar.png',
                  fit: BoxFit.cover,
                ),
    );
  }

  Widget _buildPostFormImageControl() {
    return Container(
        alignment: Alignment.center,
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
          onPressed: _loadAssets,
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
          _buildPostFormControl(),
          SizedBox(width: 20.0),
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
      children: <Widget>[_buildPostImage(), _buildPostDialogCloseControl()],
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
            child: Text('Upload Photo',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
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
          height: 400.0,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: 400.0,
                flexibleSpace: _buildPostFormImagesStack(),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30.0),
                  child: _buildPostSynopsis(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
