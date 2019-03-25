import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  ProfileRepository _profileRepository;
  ProfileFormBloc _profileFormBloc;

  @override
  void initState() {
    _profileRepository = ProfileRepository();
    _profileFormBloc = ProfileFormBloc(profileRepository: _profileRepository);
    super.initState();
  }

  @override
  void dispose() {
    _profileFormBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileForm(profileFormBloc: _profileFormBloc),
    );
  }
}
