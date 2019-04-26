import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';

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

class PostFormButtonPressed extends PostFormEvent {
  final String title;
  final String description;
  final double price;
  final bool availability;

  PostFormButtonPressed(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.availability})
      : super([title, description, price, availability]);

  @override
  String toString() =>
      'PostFormButtonPressed { title: $title, description: $description, price: $price, availability: $availability }';
}

class PostFormBloc extends Bloc<PostFormEvent, PostFormState> {
  final PostRepository postRepository;

  PostFormBloc({@required this.postRepository});

  @override
  PostFormState get initialState => PostFormInitial();

  @override
  Stream<PostFormState> mapEventToState(
      PostFormState currentState, PostFormEvent event) async* {
    if (event is PostFormButtonPressed) {
      yield PostFormLoading();

      try {
        await postRepository.createPost(
            title: event.title,
            description: event.title,
            price: event.price,
            availability: event.availability);

        yield PostFormSuccess();
      } catch (e) {
        yield PostFormFailure(error: e.toString());
      }
    }
  }
}
