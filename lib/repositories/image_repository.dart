import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/services/services.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ImageRepository {
  final _imageService = ImageService();

  Future<List<String>> uploadImage(
      {@required String uid,
      @required ProfileImageSelectMode profileImageSelectMode,
      @required List<Asset> asset}) async {
    try {
      final uuid = Uuid();
      final String fileLocation =
          profileImageSelectMode == ProfileImageSelectMode.UserImage
              ? 'user'
              : 'page';
      final String fileName = '$uid/$fileLocation/${uuid.v1()}';

      final List<String> imageUrl =
          await _imageService.uploadImage(fileName: fileName, assets: asset);

      print('Image uploaded ${imageUrl.toList()}');
      return imageUrl;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> persistImageUrl(
      {@required List<String> imageUrl,
      @required ProfileImageSelectMode profileImageSelectMode}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    profileImageSelectMode == ProfileImageSelectMode.UserImage
        ? await pref.setString('imageUrl', imageUrl[0])
        : await pref.setString('pageImageUrl', imageUrl[0]);
  }
}
