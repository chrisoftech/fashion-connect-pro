import 'package:flutter/material.dart';

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  bool _isProductAvail = false;

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
          child: Image.asset('assets/images/temp3.jpg', fit: BoxFit.cover),
        ),
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

  // void _buildPostBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           height: 1000.0,
  //           child: CustomScrollView(
  //             slivers: <Widget>[
  //               SliverAppBar(
  //                 pinned: true,
  //                 automaticallyImplyLeading: false,
  //                 expandedHeight: 200.0,
  //                 flexibleSpace: _buildPostFormImagesStack(),
  //                 bottom: PreferredSize(
  //                   preferredSize: Size.fromHeight(30.0),
  //                   child: _buildPostSynopsis(),
  //                 ),
  //               ),
  //               SliverToBoxAdapter(child: _buildPostFormInput())
  //             ],
  //           ),
  //         );
  //       });
  // }

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
