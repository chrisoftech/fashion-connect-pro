import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';

// PROFILE FORM STATES
abstract class ProfileFormState extends Equatable {
  ProfileFormState([List props = const []]) : super(props);
}

class ProfileFormInitial extends ProfileFormState {
  @override
  String toString() => 'ProfileFormInitial';
}

class ProfileFormLoading extends ProfileFormState {
  @override
  String toString() => 'ProfileFormLoading';
}

class ProfileFormSuccess extends ProfileFormState {
  @override
  String toString() => 'ProfileFormSuccess';
}

class ProfileFormFailure extends ProfileFormState {
  final String error;

  ProfileFormFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'ProfileFormFailure';
}

// PROFILE FORM EVENTS
abstract class ProfileFormEvent extends Equatable {
  ProfileFormEvent([List props = const []]) : super(props);
}

class ProfileFormButtonPressed extends ProfileFormEvent {
  final String firstname;
  final String lastname;
  final String pageTitle;
  final String pageDescription;
  final String location;

  ProfileFormButtonPressed(
      {@required this.firstname,
      @required this.lastname,
      @required this.pageTitle,
      @required this.pageDescription,
      @required this.location})
      : super([firstname, lastname, pageTitle, pageDescription, location]);

  @override
  String toString() =>
      'ProfileFormButtonPressed { firstname: $firstname, lastname: $lastname, pageTitle: $pageTitle, pageDescription: $pageDescription, location: $location }';
}

class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  final ProfileRepository profileRepository;

  ProfileFormBloc({@required this.profileRepository})
      : assert(profileRepository != null);

  @override
  ProfileFormState get initialState => ProfileFormInitial();

  @override
  void onTransition(Transition<ProfileFormEvent, ProfileFormState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void onProfileFormButtonPressed(
      {@required String firstname,
      @required String lastname,
      @required String pageTitle,
      @required String pageDescription,
      @required String location}) {
    dispatch(ProfileFormButtonPressed(
        firstname: firstname,
        lastname: lastname,
        pageTitle: pageTitle,
        pageDescription: pageDescription,
        location: location));
  }

  @override
  Stream<ProfileFormState> mapEventToState(
      ProfileFormState currentState, ProfileFormEvent event) async* {
    if (event is ProfileFormButtonPressed) {
      yield ProfileFormLoading();

      try {
        await profileRepository.createProfile(
          firstname: event.firstname,
          lastname: event.lastname,
          pageTitle: event.pageTitle,
          pageDescription: event.pageDescription,
          location: event.location,
        );

        await profileRepository.fetchProfile();

        yield ProfileFormSuccess();
      } catch (e) {
        yield ProfileFormFailure(error: e);
      }
    }
  }
}
