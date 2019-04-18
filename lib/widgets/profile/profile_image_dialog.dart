import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';

class ProfileImageDialog extends StatefulWidget {
  final String imageUrl;
  final Profile profile;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ProfileImageSelectMode profileImageSelectMode;

  const ProfileImageDialog(
      {Key key,
      @required this.imageUrl,
      @required this.profile,
      @required this.scaffoldKey,
      @required this.profileImageSelectMode})
      : super(key: key);

  @override
  _ProfileImageDialogState createState() => _ProfileImageDialogState();
}

class _ProfileImageDialogState extends State<ProfileImageDialog> {
  ImageUploadBloc _imageUploadBloc;
  ImageRepository _imageRepository;
  
  List<Asset> _images = List<Asset>();
  String _error;

  String get _imageUrl => widget.imageUrl ?? '';
  Profile get _profile => widget.profile;
  GlobalKey<ScaffoldState> get _scaffoldKey => widget.scaffoldKey;
  ProfileImageSelectMode get _profileImageSelectMode =>
      widget.profileImageSelectMode ?? false; // select mode for profile image

  @override
  void initState() {
    _imageRepository = ImageRepository();
    _imageUploadBloc = ImageUploadBloc(imageRepository: _imageRepository);
    super.initState();
  }

  Future<void> _loadAssets() async {
    _scaffoldKey.currentState.hideCurrentSnackBar();

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

  Widget _buildPostDialogActionControl() {
    return Positioned(
      top: 0.0,
      right: 10.0,
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
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
                Navigator.of(context).pop();
              },
            ),
          ],
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

  Widget _buildPostSynopsis({@required ImageUploadState state}) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: _screenWidth,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
        ),
      ),
      child: Row(
        children: <Widget>[
          _buildPostFormControl(state: state),
        ],
      ),
    );
  }

  Widget _buildPostFormImagesStack() {
    return Stack(
      children: <Widget>[_buildPostImage(), _buildPostDialogActionControl()],
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Widget _buildPostFormControl({@required ImageUploadState state}) {
    return Expanded(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: () {
            _submitForm();
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
            child: state is ImageUploadLoading
                ? CircularProgressIndicator()
                : Text('Upload Photo',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    _scaffoldKey.currentState.hideCurrentSnackBar();

    if (_images.length < 1) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('No image is selected!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _imageUploadBloc.onImageUploadButtonPressed(
        uid: _profile.uid,
        asset: _images,
        profileImageSelectMode: _profileImageSelectMode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageUploadEvent, ImageUploadState>(
        bloc: _imageUploadBloc,
        builder: (BuildContext context, ImageUploadState state) {
          if (state is ImageUploadFailure) {
            _onWidgetDidBuild(() {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  // content: Text('${state.error}'),
                  content: Text('Oops! An error occured while uploading image'),
                  backgroundColor: Colors.red,
                ),
              );
              _imageUploadBloc.onImageUploadReset();
            });
          }

          if (state is ImageUploadSuccess) {
            _onWidgetDidBuild(() {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('Image uploaded successfully'),
                  backgroundColor: Colors.black,
                ),
              );
              _imageUploadBloc.onImageUploadReset();
              Navigator.of(context).pop();
            });
          }

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
                          child: _buildPostSynopsis(state: state)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
