import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:fashion_connect/services/services.dart';
import 'package:meta/meta.dart';

class PostRepository {
  final _profileService = PostService();
  final _profileRepository = ProfileRepository();

  Future<void> createPost(
      {@required String title,
      @required String description,
      @required double price,
      @required bool availability}) async {
    try {
      final Profile userProfile = await _profileRepository.getProfile;
      return await _profileService.createPost(
          title: title,
          description: description,
          price: price,
          availability: availability,
          userProfile: userProfile);
    } catch (e) {
      throw (e);
    }
  }
}
