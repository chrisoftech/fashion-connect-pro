import 'package:fashion_connect/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileForm extends StatefulWidget {
  final ProfileFormBloc profileFormBloc;

  const ProfileForm({Key key, @required this.profileFormBloc})
      : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  AuthBloc _authBloc;

  ProfileFormBloc get _profileFormBloc => widget.profileFormBloc;

  final Map<String, dynamic> _formData = {
    'firstname': null,
    'lastname': null,
    'mobilePhone': null,
    'otherPhone': null,
    'address': null
  };

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  void _hideKeyPad() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _buildFirstNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: 'First Name',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Firstname is required!';
        }
      },
      onSaved: (String value) {
        _formData['firstname'] =
            '${value[0].toUpperCase()}${value.substring(1)}';
      },
    );
  }

  Widget _buildLastNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: 'Last Name',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Lastname is required!';
        }
      },
      onSaved: (String value) {
        _formData['lastname'] =
            '${value[0].toUpperCase()}${value.substring(1)}';
      },
    );
  }

  Widget _buildMobilePhoneTextField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      maxLength: 9,
      decoration: InputDecoration(
          filled: true,
          labelText: 'Mobile Phone',
          prefixText: '+233 ',
          suffixIcon: Icon(Icons.phone_android)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Mobile phone number is required!';
        }
      },
      onSaved: (String value) {
        _formData['mobilePhone'] = value;
      },
    );
  }

  Widget _buildOtherPhoneTextField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      maxLength: 9,
      decoration: InputDecoration(
          filled: true,
          labelText: 'Other Phone',
          prefixText: '+233 ',
          suffixIcon: Icon(Icons.local_phone)),
      onSaved: (String value) {
        _formData['otherPhone'] = value;
      },
    );
  }

  Widget _buildAddresseTextField() {
    return TextFormField(
      decoration: InputDecoration(
          filled: true,
          labelText: 'Residential Address',
          suffixIcon: Icon(Icons.location_on)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is required!';
        }
      },
      onSaved: (String value) {
        _formData['address'] = '${value[0].toUpperCase()}${value.substring(1)}';
      },
    );
  }

  Widget _buildFormControls(
      {@required BuildContext context, @required ProfileFormState state}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            _hideKeyPad();
            _authBloc.onLoggedOut();
          },
          child: Container(
            height: 40.0,
            width: 80.0,
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Text('Cancel',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ),
        ),
        InkWell(
          onTap: state is! ProfileFormLoading ? _submitForm : null,
          child: Container(
            height: 40.0,
            width: 160.0,
            color: Color.fromRGBO(59, 70, 80, 1),
            alignment: Alignment.center,
            child: state is ProfileFormLoading
                ? CircularProgressIndicator()
                : Text('Save & Continue',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  void _submitForm() {
    _hideKeyPad();
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    _profileFormBloc.onProfileFormButtonPressed(
        firstname: _formData['firstname'],
        lastname: _formData['lastname'],
        mobilePhone: _formData['mobilePhone'],
        otherPhone: _formData['otherPhone'],
        address: _formData['address']);
  }

  Widget _buildPageContent({@required ProfileFormState state}) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _targetWidth = _deviceWidth > 550.0 ? 500.0 : _deviceWidth * .90;

    return GestureDetector(
      onTap: _hideKeyPad,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/auth_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.5), BlendMode.darken),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: _targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text('Thank you for signing-up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                        'Complete the registration process by filling & navigating through the signup wizard.',
                        style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 30),
                    _buildFirstNameTextField(),
                    SizedBox(height: 20.0),
                    _buildLastNameTextField(),
                    SizedBox(height: 20.0),
                    _buildMobilePhoneTextField(),
                    _buildOtherPhoneTextField(),
                    _buildAddresseTextField(),
                    SizedBox(height: 40),
                    _buildFormControls(context: context, state: state),
                  ],
                ),
              ),
            ),
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
    return BlocBuilder<ProfileFormEvent, ProfileFormState>(
      bloc: _profileFormBloc,
      builder: (BuildContext context, ProfileFormState state) {
        if (state is ProfileFormSuccess) {
          _onWidgetDidBuild(() {
            Navigator.of(context).pushReplacementNamed('/timeline');
          });
        }

        if (state is ProfileFormFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return _buildPageContent(state: state);
      },
    );
  }
}
