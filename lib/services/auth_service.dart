import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class AuthService {
  final _db = FirebaseAuth.instance;

  Future<FirebaseUser> signInWithEmailAndPassword(
      {@required String username, @required String password}) {
    return _db.signInWithEmailAndPassword(email: username, password: password);
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      {@required String username, @required String password}) {
    return _db.createUserWithEmailAndPassword(
        email: username, password: password);
  }

  Future<void> signout() {
    return _db.signOut();
  }
}
