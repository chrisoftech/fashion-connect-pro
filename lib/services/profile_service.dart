import 'package:meta/meta.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final _db = Firestore.instance;
  final _serverTimestamp = FieldValue.serverTimestamp();

  Future<DocumentSnapshot> fetchProfile({@required String uid}) {
      return _db.collection('profile').document(uid).get();
  }

  Future<void> createProfile(
      {@required String uid,
      @required String firstname,
      @required String lastname,
      @required String mobilePhone,
      @required String otherPhone,
      @required String address}) {
    return _db.collection('profile').document(uid).setData({
      'firstname': firstname,
      'lastname': lastname,
      'mobilePhone': mobilePhone,
      'otherPhone': otherPhone,
      'address': address,
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp
    }, merge: true);
  }
}
