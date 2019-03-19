import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<bool> isAuthenticated() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<User> authenticate(
      {@required String username,
      @required String password,
      @required AuthMode authMode}) async {
    FirebaseUser firebaseUser;

    try {
      authMode == AuthMode.Login
          ? firebaseUser = await _authService.signInWithEmailAndPassword(
              username: username, password: password)
          : firebaseUser = await _authService.createUserWithEmailAndPassword(
              username: username, password: password);

      return User(uid: firebaseUser.uid, username: username);
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> persistUser({@required User user}) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> signout() async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }
}
