import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:meta/meta.dart';

class PostService {
  final _db = Firestore.instance;
  final _serverTimestamp = FieldValue.serverTimestamp();

  Future<QuerySnapshot> fetchPosts({@required Post lastVisible}) {
    return lastVisible == null
        ? _db
            .collection('posts')
            .orderBy('lastUpdate', descending: true)
            .limit(3)
            .getDocuments()
        : _db
            .collection('posts')
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisible.lastUpdate])
            .limit(3)
            .getDocuments();
  }

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
      'postImageUrls': <String>[],
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp
    });
  }

  Future<void> setPostImage(
      {@required String postId, @required List<String> postImageUrls}) {
    return _db
        .collection('posts')
        .document(postId)
        .setData({'postImageUrls': postImageUrls}, merge: true);
  }
}
