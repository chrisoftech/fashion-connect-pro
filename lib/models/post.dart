import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Post extends Equatable {
  final String postId;
  final String title;
  final String description;
  final double price;
  final bool isAvailable;
  final String uid;
  final String pageTitle;
  final String pageImageUrl;
  final List<dynamic> postImageUrls;
  final dynamic created;
  final dynamic lastUpdate;

  Post(
      {@required this.postId,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.isAvailable,
      @required this.uid,
      @required this.pageTitle,
      @required this.pageImageUrl,
      @required this.postImageUrls,
      @required this.created,
      @required this.lastUpdate})
      : super([
          postId,
          title,
          description,
          price,
          isAvailable,
          uid,
          pageTitle,
          pageImageUrl,
          postImageUrls,
          created,
          lastUpdate
        ]);

  @override
  String toString() => 'Post { postId: $postId }';
}
