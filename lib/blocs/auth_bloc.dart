import 'package:equatable/equatable.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

// AUTH STATES
abstract class AuthState extends Equatable {}

class AuthUninitialized extends AuthState {
  @override
  String toString() => 'AuthUninitialized';
}

class AuthAuthenticated extends AuthState {
  @override
  String toString() => 'AuthAuthenticated';
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
  final String token;

  AuthLoggedIn({@required this.token}) : super([token]);

  @override
  String toString() => 'AuthLoggedIn { token: $token } ';
}

class AuthLoggedOut extends AuthEvent {
  @override
  String toString() => 'AuthLoggedOut';
}

// AUTH BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({@required this.authRepository}) : assert(authRepository != null);

  @override
  AuthState get initialState => AuthUninitialized();

  void onAppStarted() {
    dispatch(AppStarted());
  }

  void onLoggedIn({@required String token}) {
    dispatch(AuthLoggedIn(token: token));
  }
  
  void onLoggedOut() {
    dispatch(AuthLoggedOut());
  }

  @override
  Stream<AuthState> mapEventToState(
      AuthState currentState, AuthEvent event) async* {
    if (event is AppStarted) {
      bool isAuthenticated = await authRepository.isAuthenticated();

      if (isAuthenticated) {
        yield AuthAuthenticated();
      } else {
        yield AuthUnauthenticated();
      }
    }

    if (event is AuthLoggedIn) {
      yield AuthLoading();
      await authRepository.persistUser(token: event.token);
      yield AuthAuthenticated();
    }

    if (event is AuthLoggedOut) {
      yield AuthLoading();
      await authRepository.signout();
      yield AuthUnauthenticated();
    }
  }
}
