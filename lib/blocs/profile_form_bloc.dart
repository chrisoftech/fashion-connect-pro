import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
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
  final String mobilePhone;
  final String otherPhone;
  final String address;

  ProfileFormButtonPressed(
      {@required this.firstname,
      @required this.lastname,
      @required this.mobilePhone,
      @required this.otherPhone,
      @required this.address})
      : super([firstname, lastname, mobilePhone, otherPhone, address]);

  @override
  String toString() =>
      'ProfileFormButtonPressed { firstname: $firstname, lastname: $lastname, mobilePhone: $mobilePhone, otherPhone: $otherPhone, address: $address }';
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
      @required String mobilePhone,
      @required String otherPhone,
      @required String address}) {
    dispatch(ProfileFormButtonPressed(
        firstname: firstname,
        lastname: lastname,
        mobilePhone: mobilePhone,
        otherPhone: otherPhone,
        address: address));
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
          mobilePhone: event.mobilePhone,
          otherPhone: event.otherPhone,
          address: event.address,
        );

        await profileRepository.fetchProfile();

        yield ProfileFormSuccess();
      } catch (e) {
        yield ProfileFormFailure(error: e);
      }
    }
  }
}
