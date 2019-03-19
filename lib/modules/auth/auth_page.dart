import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  final AuthRepository authRepository;

  const AuthPage({Key key, @required this.authRepository})
      : assert(authRepository != null),
        super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthBloc _authBloc;
  LoginBloc _loginBloc;
  AuthForm _authForm;

  AuthRepository get _authRepository => widget.authRepository;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _loginBloc =
        LoginBloc(authBloc: _authBloc, authRepository: _authRepository);
    _authForm = AuthForm(authBloc: _authBloc, loginBloc: _loginBloc,);
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _authForm,
    );
  }
}
