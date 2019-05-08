import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/utilities/utilities.dart';
import 'package:fashion_connect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Posts extends StatefulWidget {
  final PostBloc postBloc;

  const Posts({Key key, @required this.postBloc}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  PostBloc get _postBloc => widget.postBloc;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      print('sroll next');
      _postBloc.onFetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _postsContentHeight =
        _screenHeight - 220.0; // sliver expanded height;

    return BlocBuilder<PostEvent, PostState>(
      bloc: _postBloc,
      builder: (BuildContext context, PostState state) {
        if (state is PostUninitialized) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is PostError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text('Failed to fetch post(s)!'),
            ),
          );
        }

        if (state is PostLoaded) {
          if (state.posts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text('No post(s) uploaded yet!'),
              ),
            );
          }

          return Container(
            height: _postsContentHeight,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                ? state.postsUser.length
                : state.postsUser.length + 1,
              itemBuilder: (BuildContext context, int index) {
                // final PostUser postUser = state.postsUser[index];

                return index >= state.postsUser.length
                    ? BottomLoader()
                    : PostItem(
                        postUser: state.postsUser[index],
                      );
              },
            ),
          );
        }
      },
    );
  }
}
