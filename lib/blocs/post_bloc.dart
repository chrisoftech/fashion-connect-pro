import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final bool hasReachedMax;

  PostLoaded({@required this.posts, @required this.hasReachedMax})
      : super([posts, hasReachedMax]);

  PostLoaded copyWith({List<Post> posts, bool hasReachedMax}) {
    return PostLoaded(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
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
    bool _hasReachedMax(PostState state) =>
        state is PostLoaded && state.hasReachedMax;

    if (event is FetchPosts && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          List<Post> posts = await postRepository.fetchPosts(lastVisible: null);

          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }

        if (currentState is PostLoaded) {
          final List<Post> currentPosts = (currentState as PostLoaded).posts;

          final Post lastVisible = currentPosts[currentPosts.length - 1];

          List<Post> posts =
              await postRepository.fetchPosts(lastVisible: lastVisible);

          yield posts.isEmpty
              ? (currentState as PostLoaded).copyWith(hasReachedMax: true)
              : PostLoaded(
                  posts: (currentState as PostLoaded).posts + posts,
                  hasReachedMax: false);
        }
      } catch (e) {
        print(e.toString());
        yield PostError(error: e.toString());
      }
    }
  }
}
