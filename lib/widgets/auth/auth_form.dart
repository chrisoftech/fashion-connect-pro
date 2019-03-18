import 'package:fashion_connect/models/models.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.Login;

  Map<String, dynamic> _formData = {'username': null, 'password': null};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  Widget _buildUsernameTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Enter Phone Number',
      ),
      validator: (String value) {
        if (value.isEmpty || value.length != 10) {
          return 'Phone number should be 10 characters';
        }
      },
      onSaved: (String value) {
        _formData['username'] = '$value@fashion_konnect.com';
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration:
          InputDecoration(labelText: 'Password', hintText: 'Enter password'),
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password should be 6+ characters';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Enter password confirmation'),
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match!';
        }
      },
    );
  }

  Widget _buildForgotPasswordControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Forgot Password?',
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
      ],
    );
  }

  Widget _buildLoginControl({@required BuildContext context}) {
    return Expanded(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: submitForm,
          child: Container(
            height: 40.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Text(_authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void submitForm() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState.validate()) {
      return;
    }

    print('${_formData['username']}, ${_formData['password']}');
  }

  Widget _buildAuthModeControl({@required BuildContext context}) {
    return Container(
      height: 50.0,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _authMode == AuthMode.Login
                  ? 'Don\'t have an account yet?'
                  : 'Already have an account?',
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            ),
            // SizedBox(width: 10.0),
            GestureDetector(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Text(_authMode == AuthMode.Login ? 'Sign Up' : 'Login',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                ),
                onTap: () {
                  setState(() {
                    _authMode == AuthMode.Login
                        ? _authMode = AuthMode.SignUp
                        : _authMode = AuthMode.Login;

                    _formKey.currentState.reset();
                    _passwordController.text = '';
                  });
                })
          ],
        ),
      ),
    );
  }

  Widget _pageContent() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 350.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Sign Up',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              _buildUsernameTextField(),
                              SizedBox(height: 15.0),
                              _buildPasswordTextField(),
                              SizedBox(height: 15.0),
                              _authMode == AuthMode.SignUp
                                  ? _buildConfirmPasswordTextField()
                                  : Container(),
                              SizedBox(height: 15.0),
                              _authMode == AuthMode.Login
                                  ? _buildForgotPasswordControl()
                                  : Container(),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildLoginControl(context: context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildAuthModeControl(context: context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pageContent();
  }
}
