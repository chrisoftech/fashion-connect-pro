import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/image_repository.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/asset.dart';

// IMAGE UPLOAD STATES
abstract class ImageUploadState extends Equatable {
  ImageUploadState([List props = const []]) : super(props);
}

class ImageUploadInitial extends ImageUploadState {
  @override
  String toString() => 'ImageUploadIntial';
}

class ImageUploadLoading extends ImageUploadState {
  @override
  String toString() => 'ImageUploadLoading';
}

class ImageUploadSuccess extends ImageUploadState {
  final List<String> imageUrl;

  ImageUploadSuccess({@required this.imageUrl}) : super([imageUrl]);

  @override
  String toString() => 'ImageUploadSuccess';
}

class ImageUploadFailure extends ImageUploadState {
  final String error;

  ImageUploadFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'ImageUploadError';
}

// IMAGE UPLOAD EVENTS
abstract class ImageUploadEvent extends Equatable {
  ImageUploadEvent([List props = const []]) : super(props);
}

class ImageUploadReset extends ImageUploadEvent {
  @override
  String toString() => 'ImageUploadReset';
}

class ImageUploadButtonPressed extends ImageUploadEvent {
  final String uid;
  final List<Asset> asset;
  final ProfileImageSelectMode profileImageSelectMode;

  ImageUploadButtonPressed(
      {@required this.uid,
      @required this.asset,
      @required this.profileImageSelectMode})
      : super([uid, asset, profileImageSelectMode]);
}

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  final ImageRepository imageRepository;

  ImageUploadBloc({@required this.imageRepository});

  @override
  ImageUploadState get initialState => ImageUploadInitial();

  void onImageUploadReset() {
    dispatch(ImageUploadReset());
  }

  void onImageUploadButtonPressed(
      {@required String uid,
      @required List<Asset> asset,
      @required ProfileImageSelectMode profileImageSelectMode}) {
    dispatch(ImageUploadButtonPressed(
        uid: uid,
        asset: asset,
        profileImageSelectMode: profileImageSelectMode));
  }

  @override
  Stream<ImageUploadState> mapEventToState(ImageUploadEvent event) async* {
    if (event is ImageUploadReset) {
      yield ImageUploadInitial();
    }

    if (event is ImageUploadButtonPressed) {
      yield ImageUploadLoading();

      try {
        final List<String> imageUrl = await imageRepository.uploadProfileImage(
            uid: event.uid,
            asset: event.asset,
            profileImageSelectMode: event.profileImageSelectMode);

        await imageRepository.deleteExistingProfileImage(
            profileImageSelectMode: event.profileImageSelectMode);

        await imageRepository.persistProfileImageUrl(
            uid: event.uid,
            imageUrl: imageUrl,
            profileImageSelectMode: event.profileImageSelectMode);
        yield ImageUploadSuccess(imageUrl: imageUrl);
      } catch (e) {
        print('Bloc Upload error ${e.toString()}');
        yield ImageUploadFailure(error: e.toString());
      }
    }
  }
}
