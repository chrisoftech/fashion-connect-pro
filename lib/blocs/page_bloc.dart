import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

// PAGE STATES
abstract class PageState extends Equatable {
  PageState([List props = const []]) : super(props);
}

class PageUnitialized extends PageState {
  @override
  String toString() => 'PageUnitialized';
}

class PageError extends PageState {
  @override
  String toString() => 'PageError';
}

class PageLoaded extends PageState {
  final List<Page> pages;

  PageLoaded({@required this.pages}) : super([pages]);

  PageLoaded copyWith({@required List<Page> pages}) {
    return PageLoaded(pages: pages ?? this.pages);
  }

  @override
  String toString() => 'PageLoaded { pages: ${pages.length} }';
}

// PAGE EVENTS
abstract class PageEvent extends Equatable {}

class FetchPages extends PageEvent {
  @override
  String toString() => 'FetchPages';
}

class PageBloc extends Bloc<PageEvent, PageState> {
  final _pageRepository = PageRepository();

  @override
  PageState get initialState => PageUnitialized();

  @override
  Stream<PageEvent> transform(Stream<PageEvent> events) {
    return (events as Observable<PageEvent>)
        .debounce(Duration(milliseconds: 500));
  }

  @override
  void onTransition(Transition<PageEvent, PageState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void onFetchPages() {
    dispatch(FetchPages());
  }

  @override
  Stream<PageState> mapEventToState(
      PageState currentState, PageEvent event) async* {
    if (event is FetchPages) {
      try {
        final pages = await _pageRepository.fetchPages();
        yield PageLoaded(pages: pages);
      } catch (e) {
        print('Fetch page error { ${e.toString} }');
        yield PageError();
      }
    }
  }
}
