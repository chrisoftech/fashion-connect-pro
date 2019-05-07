import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/services/services.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostRepository {
  final _postService = PostService();

  final _profileRepository = ProfileRepository();
  final _imageRepository = ImageRepository();

  Future<List<String>> _createPostImage(
      {@required String uid,
      @required String postId,
      @required List<Asset> assets}) async {
    return await _imageRepository.uploadPostImage(
        uid: uid, postId: postId, assets: assets);
  }

  Future<List<Post>> fetchPosts({@required Post lastVisible}) async {
    try {
      QuerySnapshot snapshot =
          await _postService.fetchPosts(lastVisible: lastVisible);

      final List<Post> posts = [];

      if (snapshot.documents.length < 1) return posts;
      snapshot.documents.forEach((DocumentSnapshot snap) {
        final String postId = snap.documentID;

        posts.add(
          Post(
            postId: postId,
            title: snap['title'],
            description: snap['description'],
            price: snap['price'],
            isAvailable: snap['isAvailable'],
            uid: snap['uid'],
            pageTitle: snap['pageTitle'],
            pageImageUrl: snap['pageImageUrl'],
            postImageUrls: snap['postImageUrls'],
            created: snap['created'],
            lastUpdate: snap['lastUpdate'],
          ),
        );
      });

      return posts;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> createPost(
      {@required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<Asset> assets}) async {
    try {
      final Profile profile = await _profileRepository.getProfile;
      final String uid = profile.uid;
      final String pageTitle = profile.page.pageTitle;
      final String pageImageUrl = profile.page.pageImageUrl;

      DocumentReference documentReference = await _postService.createPost(
        title: title,
        description: description,
        price: price,
        isAvailable: isAvailable,
        uid: uid,
        pageTitle: pageTitle,
        pageImageUrl: pageImageUrl,
      );

      final postId = documentReference.documentID;

      // List<String> postImageUrls =
      //     await _createPostImage(uid: uid, postId: postId, assets: assets);

      // return await _postService.setPostImage(
      //     postId: postId, postImageUrls: postImageUrls);

      return await _createPostImage(uid: uid, postId: postId, assets: assets)
          .then((List<String> postImageUrls) async {
        print('after upload');
        return await _postService.setPostImage(
            postId: postId, postImageUrls: postImageUrls);
      });

      // return;
    } catch (e) {
      throw (e);
    }
  }
}
