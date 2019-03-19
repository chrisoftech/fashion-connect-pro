import 'package:meta/meta.dart';

class AuthRepository {
  Future<bool> isAuthenticated() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<String> authenticate(
      {@required String username, @required String password}) async {
    await Future.delayed(Duration(seconds: 2));
    return 'token';
  }

  Future<void> persistUser({@required String token}) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> signout() async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }
}
