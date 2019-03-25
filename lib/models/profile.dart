import 'package:meta/meta.dart';

class Profile {
  final String uid;
  final String firstname;
  final String lastname;
  final String mobilePhone;
  final String otherPhone;
  final String address;
  final dynamic created;
  final dynamic lastUpdate;

  Profile(
      {@required this.uid,
      @required this.firstname,
      @required this.lastname,
      @required this.mobilePhone,
      @required this.otherPhone,
      @required this.address,
      @required this.created,
      @required this.lastUpdate});
}
