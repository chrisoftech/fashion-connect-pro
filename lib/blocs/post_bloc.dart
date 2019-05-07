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
  final List<PostUser> postsUser;
  final bool hasReachedMax;

  PostLoaded(
      {@required this.posts,
      @required this.postsUser,
      @required this.hasReachedMax})
      : super([posts, postsUser, hasReachedMax]);

  PostLoaded copyWith(
      {List<Post> posts, List<PostUser> postsUser, bool hasReachedMax}) {
    return PostLoaded(
        posts: posts ?? this.posts,
        postsUser: postsUser ?? this.postsUser,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, postsUser: ${postsUser.length}, hasReachedMax: $hasReachedMax }';
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
          List<PostUser> postsUser =
              await postRepository.fetchPostsUsers(posts: posts);

          yield PostLoaded(
              posts: posts, postsUser: postsUser, hasReachedMax: false);
          return;
        }

        if (currentState is PostLoaded) {
          final List<Post> currentPosts = (currentState as PostLoaded).posts;

          final Post lastVisible = currentPosts[currentPosts.length - 1];

          List<Post> posts =
              await postRepository.fetchPosts(lastVisible: lastVisible);

          List<PostUser> postsUser =
              await postRepository.fetchPostsUsers(posts: posts);

          yield posts.isEmpty
              ? (currentState as PostLoaded).copyWith(hasReachedMax: true)
              : PostLoaded(
                  posts: (currentState as PostLoaded).posts + posts,
                  postsUser: (currentState as PostLoaded).postsUser + postsUser,
                  hasReachedMax: false);
        }
      } catch (e) {
        print(e.toString());
        yield PostError(error: e.toString());
      }
    }
  }
}
