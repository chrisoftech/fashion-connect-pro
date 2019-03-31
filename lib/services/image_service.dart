import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/asset.dart';

class ImageService {
  Future<String> uploadImage({@required String fileName, @required Asset asset}) async {
    String photoUrl = '';

    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();

    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot;

    // Release the image data
    asset.releaseOriginal();

    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          print('Upload success');
        }, onError: (err) {
          throw (err);
        });
      } else {
        throw ('This file is not an image');
      }
      return photoUrl;
    }, onError: (err) {
      print('This file is not an image');
      throw (err.toString());
    });

    return photoUrl;
  }
}
