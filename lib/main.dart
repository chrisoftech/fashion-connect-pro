import 'package:bloc/bloc.dart';
import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/modules/modules.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    super.onError(error, stacktrace);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp(
    authRepository: AuthRepository(),
    profileRepository: ProfileRepository(),
  ));
}

class MyApp extends StatefulWidget {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  const MyApp(
      {Key key,
      @required this.authRepository,
      @required this.profileRepository})
      : assert(authRepository != null),
        assert(profileRepository != null),
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthBloc _authBloc;

  AuthRepository get _authRepository => widget.authRepository;
  ProfileRepository get _profileRepository => widget.profileRepository;

  @override
  void initState() {
    _authBloc = AuthBloc(
        authRepository: _authRepository, profileRepository: _profileRepository);
    _authBloc.onAppStarted();
    super.initState();
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  Widget _buildHomePage() {
    return BlocBuilder<AuthEvent, AuthState>(
      bloc: _authBloc,
      builder: (BuildContext context, AuthState state) {
        if (state is AuthUninitialized) {
          return SplashPage();
        }

        if (state is AuthLoading) {
          return LoadingIndicator();
        }

        if (state is AuthAuthenticated) {
          return state.hasProfile ? HomePage() : ProfileFormPage();
        }

        if (state is AuthUnauthenticated) {
          return AuthPage(
              authRepository: _authRepository,
              profileRepository: _profileRepository);
        }
      },
    );
  }

  @override  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      bloc: _authBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fashion Connect',
        theme: ThemeData(
          fontFamily: 'QuickSand',
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
          accentColor: Colors.yellow[700],
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => _buildHomePage(),
          '/home': (BuildContext context) => HomePage(),
          '/profile': (BuildContext context) => UserProfilePage(),
          '/timeline': (BuildContext context) => TimelinePage()
        },
      ),
    );
  }
}
