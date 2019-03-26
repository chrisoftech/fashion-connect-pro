import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PageService {
  final _db = Firestore.instance;
  final _serverTimestamp = FieldValue.serverTimestamp();

  Future<QuerySnapshot> fetchPages() {
    return _db.collection('pages').getDocuments();
  }

  Future<DocumentSnapshot> fetchPage({@required String uid}) {
    return _db.collection('pages').document(uid).get();
  }

  Future<void> createPage(
      {@required String uid,
      @required String pageTitle,
      String pageDescription}) {
    return _db.collection('pages').document(uid).setData({
      'pageTitle': pageTitle,
      'pageDescription': pageDescription,
      'pageImageUrl': '',
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp
    }, merge: true);
  }
}
