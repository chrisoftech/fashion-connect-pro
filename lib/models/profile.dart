import 'package:equatable/equatable.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:meta/meta.dart';

class Profile extends Equatable {
  final String uid;
  final String firstname;
  final String lastname;
  final String mobilePhone;
  final Page page;
  final String location;
  final dynamic created;
  final dynamic lastUpdate;

  Profile(
      {@required this.uid,
      @required this.firstname,
      @required this.lastname,
      @required this.mobilePhone,
      @required this.page,
      @required this.location,
      @required this.created,
      @required this.lastUpdate})
      : super([
          uid,
          firstname,
          lastname,
          mobilePhone,
          page,
          location,
          created,
          lastUpdate
        ]);

  @override
  String toString() => 'Page { uid: $uid }';
}
