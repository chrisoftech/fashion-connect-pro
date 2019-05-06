import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class PostFormState extends Equatable {
  PostFormState([List props = const []]) : super(props);
}

class PostFormInitial extends PostFormState {
  @override
  String toString() => 'PostFormInitial';
}

class PostFormLoading extends PostFormState {
  @override
  String toString() => 'PostFormLoading';
}

class PostFormSuccess extends PostFormState {
  @override
  String toString() => 'PostFormSuccess';
}

class PostFormFailure extends PostFormState {
  final String error;

  PostFormFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'PostFormFailure { error: $error }';
}

abstract class PostFormEvent extends Equatable {
  PostFormEvent([List props = const []]) : super(props);
}

class PostFormReset extends PostFormEvent {
  @override
  String toString() => 'PostFormReset';
}

class PostFormButtonPressed extends PostFormEvent {
  final String title;
  final String description;
  final double price;
  final bool isAvailable;
  final List<Asset> assets;

  PostFormButtonPressed(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.isAvailable,
      @required this.assets})
      : super([title, description, price, isAvailable, assets]);

  @override
  String toString() =>
      'PostFormButtonPressed { title: $title, description: $description, price: $price, availability: $isAvailable, assets: ${assets.length} }';
}

class PostFormBloc extends Bloc<PostFormEvent, PostFormState> {
  final PostRepository postRepository;

  PostFormBloc({@required this.postRepository});

  @override
  PostFormState get initialState => PostFormInitial();

  void onPostFormReset() {
    dispatch(PostFormReset());
  }

  void onPostFormButtonPressed(
      {@required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<Asset> assets}) {
    dispatch(PostFormButtonPressed(
        title: title,
        description: description,
        price: price,
        isAvailable: isAvailable,
        assets: assets));
  }

  @override
  Stream<PostFormState> mapEventToState(PostFormEvent event) async* {
    if (event is PostFormButtonPressed) {
      yield PostFormLoading();

      try {
        await postRepository.createPost(
            title: event.title,
            description: event.title,
            price: event.price,
            isAvailable: event.isAvailable,
            assets: event.assets);

        yield PostFormSuccess();
      } catch (e) {
        yield PostFormFailure(error: e.toString());
      }
    }

    if (event is PostFormReset) {
      yield PostFormInitial();
    }
  }
}
