import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

// Post States
abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

class PostUninitialized extends PostState {
  @override
  String toString() => 'PostUninitialized';
}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded({this.posts}) : super([posts]);

  PostLoaded copyWith({List<Post> posts}) {
    return PostLoaded(posts: posts ?? this.posts);
  }

  @override
  String toString() => 'PostLoaded { posts: ${posts.length}}';
}

class PostError extends PostState {
  final String error;

  PostError({this.error}) : super([error]);

  @override
  String toString() => 'PostError { error: $error }';
}

// Post Events
abstract class PostEvent extends Equatable {}

class FetchPosts extends PostEvent {
  @override
  String toString() => 'FetchPosts';
}

// Post Bloc
class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({@required this.postRepository});

  @override
  Stream<PostState> transform(
    Stream<PostEvent> events,
    Stream<PostState> Function(PostEvent event) next,
  ) {
    return super.transform(
      (events as Observable<PostEvent>).debounce(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  PostState get initialState => PostUninitialized();

  void onFetchPosts() {
    dispatch(FetchPosts());
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is FetchPosts) {
      try {
        List<Post> posts = await postRepository.fetchPosts();
        yield PostLoaded(posts: posts);
      } catch (e) {
        print(e.toString());
        yield PostError(error: e.toString());
      }
    }
  }
}
