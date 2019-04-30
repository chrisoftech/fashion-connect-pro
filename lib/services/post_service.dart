import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PostService {
  final _db = Firestore.instance;
  final _serverTimestamp = FieldValue.serverTimestamp();

  Future<DocumentReference> createPost({
    @required String title,
    @required String description,
    @required double price,
    @required bool isAvailable,
    @required String uid,
    @required String pageTitle,
    @required String pageImageUrl,
  }) {
    return _db.collection('posts').add({
      'title': title,
      'description': description,
      'price': price,
      'isAvailable': isAvailable,
      'uid': uid,
      'pageTitle': pageTitle,
      'pageImageUrl': pageImageUrl,
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp
    });
  }

  Future<void> setPostImage( {
      @required String postId,
      @required List<String> postImageUrls}) {
        return _db.collection('posts').document(postId).setData({
          'postImageUrls': postImageUrls
        }, merge: true);
  }
}
