import 'package:fashion_connect/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Signout'),
          onPressed: () {
            _authBloc.onLoggedOut();
          },
        ),
      ),
    );
  }
}
