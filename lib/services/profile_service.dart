import 'package:meta/meta.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final _db = Firestore.instance;
  final _serverTimestamp = FieldValue.serverTimestamp();

  Future<DocumentSnapshot> fetchProfile({@required String uid}) {
    return _db.collection('profile').document(uid).get();
  }

  Future<QuerySnapshot> fetchProfiles() {
    return _db.collection('profile').getDocuments();
  }

  Future<void> createProfile(
      {@required String uid,
      @required String username,
      @required String firstname,
      @required String lastname,
      @required String pageTitle,
      @required String pageDescription,
      @required String location}) {
    final String mobilePhone = username.replaceAll('@fashionconnect.com', '');

    return _db.collection('profile').document(uid).setData({
      'firstname': firstname,
      'lastname': lastname,
      'mobilePhone': mobilePhone.trim(),
      'pageTitle': pageTitle,
      'pageDescription': pageDescription,
      'location': location,
      'imageUrl': '',
      'pageImageUrl': '',
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp
    }, merge: true);
  }

  Future<void> setProfileImage(
      {@required String uid, @required String imageUrl}) {
    return _db.collection('profile').document(uid).setData({
      'imageUrl': imageUrl,
      'lastUpdate': _serverTimestamp,
    }, merge: true);
  }

  Future<void> setProfilePageImage(
      {@required String uid, @required String pageImageUrl}) {
    return _db.collection('profile').document(uid).setData({
      'pageImageUrl': pageImageUrl,
      'lastUpdate': _serverTimestamp,
    }, merge: true);
  }
}
