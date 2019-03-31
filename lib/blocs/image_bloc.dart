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

class ImageUploadIntial extends ImageUploadState {
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

class ImageUploadButtonPressed extends ImageUploadEvent {
  final String uid;
  final Asset asset;
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
  ImageUploadState get initialState => ImageUploadIntial();

  @override
  Stream<ImageUploadState> mapEventToState(
      ImageUploadState currentState, ImageUploadEvent event) async* {
    if (event is ImageUploadButtonPressed) {
      yield ImageUploadLoading();

      try {
        final String imageUrl = await imageRepository.uploadImage(
            uid: event.uid,
            asset: event.asset,
            profileImageSelectMode: event.profileImageSelectMode);

        await imageRepository.persistImageUrl(
            imageUrl: imageUrl,
            profileImageSelectMode: event.profileImageSelectMode);
      } catch (e) {
        print('Bloc Upload error ${e.toString()}');
        yield ImageUploadFailure(error: e.toString());
      }
    }
  }
}
