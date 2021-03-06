import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageService {
  Future<Uint8List> _compressFile(
      {@required List<int> imageData, int quality = 20}) async {
    print("beforeCompress = ${imageData.length}");
    List<int> compressedImageData = await FlutterImageCompress.compressWithList(
        imageData,
        quality: quality);
    print("after = ${compressedImageData?.length ?? 0}");

    return Uint8List.fromList(compressedImageData);
  }

  Future<List<String>> uploadProfileImage(
      {@required String fileName, @required List<Asset> assets}) async {
    List<String> uploadUrls = [];

    await Future.wait(
            assets.map((Asset asset) async {
              ByteData byteData = await asset.requestOriginal();
              List<int> imageData = byteData.buffer.asUint8List();

              // compress file
              Uint8List compressedFile =
                  await _compressFile(imageData: imageData, quality: 30);

              StorageReference reference =
                  FirebaseStorage.instance.ref().child(fileName);
              StorageUploadTask uploadTask = reference.putData(compressedFile);
              StorageTaskSnapshot storageTaskSnapshot;

              // Release the image data
              asset.releaseOriginal();

              StorageTaskSnapshot snapshot = await uploadTask.onComplete.timeout(
                  const Duration(seconds: 60),
                  onTimeout: () =>
                      throw ('Upload could not be completed. Operation timeout'));

              if (snapshot.error == null) {
                storageTaskSnapshot = snapshot;
                final String downloadUrl =
                    await storageTaskSnapshot.ref.getDownloadURL();

                uploadUrls.add(downloadUrl);
                print('Upload success');
              } else {
                print('Error from image repo ${snapshot.error.toString()}');
                throw ('An error occured while uploading image. Upload error');
              }
            }),
            eagerError: true,
            cleanUp: (_) {
              print('eager cleaned up');
            })
        .timeout(const Duration(seconds: 60),
            onTimeout: () =>
                throw ('Upload could not be completed. Operation timeout'));

    return uploadUrls;
  }

  Future<void> deleteProfileImage({@required String imageUrl}) async {
    if (imageUrl.isNotEmpty) {
      final StorageReference reference =
          await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
      return reference.delete();
    }
  }

  Future<List<String>> uploadPostImage(
      {@required String fileLocation, @required List<Asset> assets}) async {
    List<String> uploadUrls = [];

    await Future.wait(
            assets.map((Asset asset) async {
              ByteData byteData = await asset.requestOriginal();
              List<int> imageData = byteData.buffer.asUint8List();

              // compress file
              Uint8List compressedFile =
                  await _compressFile(imageData: imageData);

              final uuid = Uuid();
              final fileName = '$fileLocation/${uuid.v1()}';

              StorageReference reference =
                  FirebaseStorage.instance.ref().child(fileName);
              StorageUploadTask uploadTask = reference.putData(compressedFile);
              StorageTaskSnapshot storageTaskSnapshot;

              // Release the image data
              asset.releaseOriginal();

              StorageTaskSnapshot snapshot = await uploadTask.onComplete.timeout(
                  const Duration(seconds: 180),
                  onTimeout: () =>
                      throw ('Upload could not be completed. Operation timeout'));

              if (snapshot.error == null) {
                storageTaskSnapshot = snapshot;
                final String downloadUrl =
                    await storageTaskSnapshot.ref.getDownloadURL();

                uploadUrls.add(downloadUrl);
                print('Upload success');
              } else {
                print('Error from image repo ${snapshot.error.toString()}');
                throw ('An error occured while uploading image. Upload error');
              }
            }),
            eagerError: true,
            cleanUp: (_) {
              print('eager cleaned up');
            })
        .timeout(const Duration(seconds: 180),
            onTimeout: () =>
                throw ('Upload could not be completed. Operation timeout'));

    return uploadUrls;
  }
}
