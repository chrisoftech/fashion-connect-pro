import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';

class PostForm extends StatefulWidget {
  final Profile profile;
  final PostFormBloc postFormBloc;

  const PostForm(
      {Key key,
      @required this.profile,
     @required this.postFormBloc})
      : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  Profile get _profile => widget.profile;
  PostFormBloc get _postFormBloc => widget.postFormBloc;

  List<Asset> _images = List<Asset>();
  String _error;

  bool _isAvailable = false;
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
  };

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _loadAssets() async {    

    setState(() {
      _images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
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
      top: 0.0,      right: 20.0,
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
                
                Navigator.of(context).pop();
              },
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
                  '${_profile.firstname} ${_profile.lastname}',
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
    );
  }

  Widget _buildPostFormImagesStack() {
    return Stack(
      children: <Widget>[_buildPostImages(), _buildPostDialogActionControl()],
    );
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Post title', filled: true, border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Post title is required!';
        }

        if (value.length > 20) {
          return 'Post title should be less than 20 characters!';
        }
      },
      onSaved: (String value) {
        _formData['title'] = '${value[0].toUpperCase()}${value.substring(1)}';
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          labelText: 'Description', filled: true, border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Post description is required!';
        }
        if (value.length > 50) {
          return 'Post description should be 40 to 50 characters long!';
        }
      },
      onSaved: (String value) {
        _formData['description'] =
            '${value[0].toUpperCase()}${value.substring(1)}';
      },    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Price', filled: true, border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number!';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildAvailabilityControlField() {
    return SwitchListTile.adaptive(
      value: _isAvailable,
      activeColor: Theme.of(context).accentColor,
      title: Text('Is this product available?'),
      onChanged: (bool value) {
        
        setState(() {
          _isAvailable = value;
        });
      },
    );
  }

  Widget _buildPostFormControl({@required PostFormState state}) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: state is! PostFormLoading ? _submitForm : null,
        child: Container(
          height: 60.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: state is PostFormLoading
              ? CircularProgressIndicator()
              : Text('Post Product',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                     fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  _buildMessageDialog({@required String title, @required String content,}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: Text('$content'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _submitForm() {
    
    FocusScope.of(context).requestFocus(FocusNode());

    if (_images.length < 1) {
      final String content = 'No image(s) is selected!';
      _buildMessageDialog(title: 'Error', content: content);
      return;
    }


    if (!_formKey.currentState.validate()) return;

    if (!_isAvailable) {
      final String content = 'Select item availability!';
      _buildMessageDialog(title: 'Error', content: content);
      return;
    }

    _formKey.currentState.save();

    _postFormBloc.onPostFormButtonPressed(
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      isAvailable: _isAvailable,
      assets: _images
    );
  }

  void _resetFormFields() {
    _formKey.currentState.reset();
    _isAvailable = false;
    _images.clear();
  }

  Widget _buildPostFormInput({@required PostFormState state}) {
     final double _screenWidth = MediaQuery.of(context).size.width;
    final double _contentWidth = _screenWidth > 550.0 ? 500.0 : _screenWidth;

    return Container(
      padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
      child: Form(
        key: _formKey,
        child: Container(
           width: _contentWidth,
          child: Column(
            children: <Widget>[
              _buildTitleTextField(),
              SizedBox(height: 20.0),
              _buildDescriptionTextField(),
              SizedBox(height: 20.0),
              _buildPriceTextField(),
              SizedBox(height: 20.0),
              _buildAvailabilityControlField(),
              SizedBox(height: 20.0),
              _buildPostFormControl(state: state),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return BlocBuilder<PostFormEvent, PostFormState>(
      bloc: _postFormBloc,
      builder: (BuildContext context, PostFormState state) {
        if (state is PostFormFailure) {
          _onWidgetDidBuild(() {
            final String content = 'Oops! An error occured while posting item';
            _buildMessageDialog(title: 'Error', content: content);
            _postFormBloc.onPostFormReset();
          });
        }

        if (state is PostFormSuccess) {
          _onWidgetDidBuild(() {
             final String content = 'Item posted successfully';
            _buildMessageDialog(title: 'Success', content: content);
            _postFormBloc.onPostFormReset();
            // _resetFormFields();
          });
        }

        // return Scaffold(
        //   body: SafeArea(
        //     child: GestureDetector(
        //       onTap: () {
        //         FocusScope.of(context).requestFocus(FocusNode());
        //       },
        //       child: Container(
        //         // height: 700.0,
        //         child: CustomScrollView(
        //           slivers: <Widget>[
        //             SliverAppBar(
        //               pinned: true,
        //               automaticallyImplyLeading: false,
        //               expandedHeight: 200.0,
        //               flexibleSpace: _buildPostFormImagesStack(),
        //               bottom: PreferredSize(
        //                 preferredSize: Size.fromHeight(30.0),
        //                 child: _buildPostSynopsis(),
        //               ),
        //             ),
        //             SliverToBoxAdapter(child: _buildPostFormInput(state: state))
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // );

        return Dialog(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              height: 700.0,
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
                  SliverToBoxAdapter(child: _buildPostFormInput(state: state))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
