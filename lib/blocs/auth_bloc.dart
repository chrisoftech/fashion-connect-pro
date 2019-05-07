import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

// AUTH STATES
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class AuthUninitialized extends AuthState {
  @override
  String toString() => 'AuthUninitialized';
}

class AuthAuthenticated extends AuthState {
  final bool hasProfile;

  AuthAuthenticated({@required this.hasProfile}) : super([hasProfile]);

  @override
  String toString() => 'AuthAuthenticated { hasProfile: $hasProfile }';
}

class AuthUnauthenticated extends AuthState {
  @override
  String toString() => 'AuthUnauthenticated';
}

class AuthLoading extends AuthState {
  @override
  String toString() => 'AuthLoading';
}

// AUTH EVENTS
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';
}

class AuthLoggedIn extends AuthEvent {
  final User user;
  final AuthMode authMode;

  AuthLoggedIn({@required this.user, @required this.authMode})
      : super([user, authMode]);

  @override
  String toString() =>
      'AuthLoggedIn { uid: ${user.uid}, username: ${user.username}, authMode: $authMode } ';
}

class AuthLoggedOut extends AuthEvent {
  @override
  String toString() => 'AuthLoggedOut';
}

// AUTH BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  AuthBloc({@required this.authRepository, @required this.profileRepository})
      : assert(authRepository != null),
        assert(profileRepository != null);

  @override
  AuthState get initialState => AuthUninitialized();

  void onAppStarted() {
    dispatch(AppStarted());
  }

  void onLoggedIn({@required User user, @required AuthMode authMode}) {
    dispatch(AuthLoggedIn(user: user, authMode: authMode));
  }

  void onLoggedOut() {
    dispatch(AuthLoggedOut());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      bool isAuthenticated = await authRepository.isAuthenticated();
      bool hasProfile = await profileRepository.hasProfile();

      if (isAuthenticated) {
        yield AuthAuthenticated(hasProfile: hasProfile);
      } else {
        yield AuthUnauthenticated();
      }
    }

    if (event is AuthLoggedIn) {
      yield AuthLoading();

      await authRepository.persistUser(
          user: event.user, authMode: event.authMode);

      await profileRepository.fetchCurrentUserProfile();

      bool hasProfile = await profileRepository.hasProfile();

      yield AuthAuthenticated(hasProfile: hasProfile);
    }

    if (event is AuthLoggedOut) {
      yield AuthLoading();
      await authRepository.signout();
      yield AuthUnauthenticated();
    }
  }
}
