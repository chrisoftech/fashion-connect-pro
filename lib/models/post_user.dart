import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:meta/meta.dart';

class PostUser extends Equatable {
 
  final Post post;
  final Profile userProfile;

  PostUser(
      {
      @required this.post,
      @required this.userProfile})
      : super([
          post,
          userProfile,
        ]);

  @override
  String toString() => 'PostUser { postId: ${post.postId}, userId: ${userProfile.uid} }';
}