import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';

// LOGIN STATES
abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'LoginFailure { error: $error }';
}

// LOGIN EVENTS
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginReset extends LoginEvent {
  @override
  String toString() => 'LoginReset';
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final AuthMode authMode;

  LoginButtonPressed(
      {@required this.username,
      @required this.password,
      @required this.authMode})
      : super([username, password, authMode]);

  @override
  String toString() =>
      'LoginButtonButtonPressed { username: $username, password: $password }';
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  LoginBloc(
      {@required this.authBloc,
      @required this.authRepository,
      @required this.profileRepository})
      : assert(authBloc != null),
        assert(authRepository != null),
        assert(profileRepository != null);

  @override
  LoginState get initialState => LoginInitial();

  void onLoginReset() {
    dispatch(LoginReset());
  }

  void onLoginButtonPressed(
      {@required String username,
      @required String password,
      @required AuthMode authMode}) {
    dispatch(LoginButtonPressed(
        username: username, password: password, authMode: authMode));
  }

  @override
  Stream<LoginState> mapEventToState(
      LoginState currentState, LoginEvent event) async* {
    if (event is LoginReset) {
      yield LoginInitial();
    }

    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final User user = await authRepository.authenticate(
            username: event.username,
            password: event.password,
            authMode: event.authMode);

        authBloc.onLoggedIn(user: user, authMode: event.authMode);
        yield LoginInitial();
      } catch (e) {
        print('Bloc error ${e.message}');
        yield LoginFailure(error: e.message);
      }
    }
  }
}
