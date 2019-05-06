import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';

// PROFILE STATES
abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super(props);
}

class ProfileUninitialized extends ProfileState {
  @override
  String toString() => 'ProfileUninitialized';
}

class ProfileError extends ProfileState {
  @override
  String toString() => 'ProfileError';
}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded({@required this.profile}) : super([profile]);

  @override
  String toString() => 'ProfileLoaded { ${profile.uid} }';
}

class ProfilesLoaded extends ProfileState {
  final List<Profile> profiles;

  ProfilesLoaded({@required this.profiles}) : super([profiles]);

  @override
  String toString() => 'ProfilesLoaded { ${profiles.length} }';
}

// PROFILE EVENTS
abstract class ProfileEvent extends Equatable {}

class FetchProfile extends ProfileEvent {
  @override
  String toString() => 'FetchProfile';
}

class FetchProfiles extends ProfileEvent {
  @override
  String toString() => 'FetchProfiles';
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({@required this.profileRepository});

  @override
  ProfileState get initialState => ProfileUninitialized();

  void onFetchProfile() {
    dispatch(FetchProfile());
  }

  void onFetchProfiles() {
    dispatch(FetchProfiles());
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchProfile) {
      try {
        final profile = await profileRepository.fetchProfile();
        yield ProfileLoaded(profile: profile);
      } catch (e) {
        print(e.toString());
        yield ProfileError();
      }
    }

    if (event is FetchProfiles) {
      try {
        final profiles = await profileRepository.fetchProfiles();
        yield ProfilesLoaded(profiles: profiles);
      } catch (e) {
        print(e.toString());
        yield ProfileError();
      }
    }
  }
}
