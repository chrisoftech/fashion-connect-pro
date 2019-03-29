import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  ProfileBloc _profileBloc;
  ProfileRepository _profileRepository;

  @override
  void initState() {
    _profileRepository = ProfileRepository();
    _profileBloc = ProfileBloc(profileRepository: _profileRepository);

    _profileBloc.onFetchProfile();
    super.initState();
  }

  @override
  void dispose() {
    _profileBloc.dispose();
    super.dispose();
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileEvent, ProfileState>(
        bloc: _profileBloc,
        builder: (BuildContext context, ProfileState state) {
          if (state is ProfileUninitialized) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProfileError) {
            _onWidgetDidBuild(() {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('An error occured when loading profile!'),
                  backgroundColor: Colors.red,
                ),
              );
              // _loginBloc.onLoginReset();
            });
          }

          if (state is ProfileLoaded) {
            return ProfileSliver(profile: state.profile);
          }
        },
      ),
    );
  }
}
