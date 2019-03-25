import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<bool> isAuthenticated() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString('uid') != null && pref.getString('username') != null)
      return true;

    return false;
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

  Future<void> persistUser(
      {@required User user, @required AuthMode authMode}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('uid', user.uid);
    await pref.setString('username', user.username);
    if (authMode == AuthMode.SignUp) {
      await pref.setBool('has_profile', false);
    }
  }

  Future<void> signout() async {
    try {
      await _authService.signout();

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('uid');
      await pref.remove('username');

      // remove profile data
      await pref.setBool('has_profile', false);
      await pref.remove('firstname');
      await pref.remove('lastname');
      await pref.remove('mobilePhone');
      await pref.remove('otherPhone');
      await pref.remove('address');
      await pref.remove('created');
      await pref.remove('lastUpdate');
    } catch (e) {
      throw (e);
    }
  }
}
