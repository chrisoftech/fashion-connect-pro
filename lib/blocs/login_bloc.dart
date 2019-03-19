import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/blocs/blocs.dart';
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

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({@required this.username, @required this.password})
      : super([username, password]);

  @override
  String toString() =>
      'LoginButtonButtonPressed { username: $username, password: $password }';
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  final AuthRepository authRepository;

  LoginBloc({@required this.authBloc, @required this.authRepository})
      : assert(authBloc != null),
        assert(authRepository != null);

  @override
  LoginState get initialState => LoginInitial();

  void onLoginButtonPressed(
      {@required String username, @required String password}) {
    dispatch(LoginButtonPressed(username: username, password: password));
  }

  @override
  Stream<LoginState> mapEventToState(
      LoginState currentState, LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final String token = await authRepository.authenticate(
            username: event.username, password: event.password);

        authBloc.onLoggedIn(token: token);
        yield LoginInitial();
      } catch (e) {
        yield LoginFailure(error: e.toString());
      }
    }
  }
}
