import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:meta/meta.dart';

class PostService {
  final _db = Firestore.instance;
  final _serverTimestamp = FieldValue.serverTimestamp();

  Future<DocumentReference> createPost(
      {@required String title,
      @required String description,
      @required double price,
      @required bool availability,
      @required Profile userProfile}) {
    return _db.collection('posts').add({
      'title': title,
      'description': description,
      'price': price,
      'availability': availability,
      'createdBy': userProfile,
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp
    });
  }
}
