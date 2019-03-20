import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<bool> isAuthenticated() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      if (pref.getString('uid') != null && pref.getString('username') != null)
        return true;

      return false;
    } catch (e) {
      throw (e);
    }
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
      throw (e);
    }
  }

  Future<void> persistUser({@required User user}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('uid', user.uid);
    await pref.setString('username', user.username);
  }

  Future<void> signout() async {
    try {
      await _authService.signout();

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('uid');
      await pref.remove('username');
    } catch (e) {
      throw (e);
    }
  }
}
