import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Page extends Equatable {
  final String uid;
  final String pageTitle;
  final String pageDescription;
  final dynamic created;
  final dynamic lastUpdate;

  Page(
      {@required this.uid,
      @required this.pageTitle,
      @required this.pageDescription,
      @required this.created,
      @required this.lastUpdate})
      : super([uid, pageTitle, pageDescription, created, lastUpdate]);

  @override
  String toString() => 'Page { uid: $uid }';
}
