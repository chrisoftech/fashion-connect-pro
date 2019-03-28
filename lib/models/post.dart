import 'package:meta/meta.dart';

class Post {
  final String postId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String createdBy;
  final dynamic created;
  final dynamic lastUpdate;

  Post(
      {@required this.postId,
      @required this.title,
      @required this.description,
      @required this.imageUrls,
      @required this.createdBy,
      @required this.created,
      @required this.lastUpdate});
}
