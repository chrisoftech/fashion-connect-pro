import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // ProfileBloc _profileBloc;
  Profile _profile;
  ProfileRepository _profileRepository;

  @override
  void initState() {
    _profileRepository = ProfileRepository();
    _fetchProfile();

    // _profileBloc = ProfileBloc(profileRepository: _profileRepository);
    // _profileBloc.onFetchProfile();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _profileBloc.dispose();
  //   super.dispose();
  // }

  Future<void> _fetchProfile() async {
    Profile profile = await _profileRepository.fetchProfile();
    setState(() {
      _profile = profile;
      print('profile updated!!!!');
    });
  }

  // void _onWidgetDidBuild(Function callback) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     callback();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _profile != null
          ? ProfileSliver(profile: _profile, fetchProfile: _fetchProfile)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
    // return Scaffold(
    //   body: BlocBuilder<ProfileEvent, ProfileState>(
    //     bloc: _profileBloc,
    //     builder: (BuildContext context, ProfileState state) {
    //       if (state is ProfileUninitialized) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }

    //       if (state is ProfileError) {
    //         _onWidgetDidBuild(() {
    //           Scaffold.of(context).showSnackBar(
    //             SnackBar(
    //               content: Text('An error occured when loading profile!'),
    //               backgroundColor: Colors.red,
    //             ),
    //           );
    //           // _loginBloc.onLoginReset();
    //         });
    //       }

    //       if (state is ProfileLoaded) {
    //         return ProfileSliver(
    //             profile: state.profile, fetchProfile: _fetchProfile);
    //       }
    //     },
    //   ),
    // );
  }
}
