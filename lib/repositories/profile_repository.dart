import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_connect/models/models.dart';
import 'package:fashion_connect/services/profile_service.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final _profileService = ProfileService();

  Future<String> get _uid async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('uid');
  }

  Future<String> get _username async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('username');
  }

  Future<bool> hasProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool('has_profile') ?? false) return true;

    return false;
  }

  Future<Profile> fetchProfile() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final String uid = await _uid;

      DocumentSnapshot documentSnapshot =
          await _profileService.fetchProfile(uid: uid);

      final _profileSnap = documentSnapshot.data;

      if (documentSnapshot.exists) {
        await pref.setBool('has_profile', true);
        await pref.setString('firstname', _profileSnap['firstname']);
        await pref.setString('lastname', _profileSnap['lastname']);
        await pref.setString('mobilePhone', _profileSnap['mobilePhone']);
        await pref.setString('pageTitle', _profileSnap['pageTitle']);
        await pref.setString(
            'pageDescription', _profileSnap['pageDescription']);
        await pref.setString('imageUrl', _profileSnap['imageUrl']);
        await pref.setString('pageImageUrl', _profileSnap['pageImageUrl']);
        await pref.setString('location', _profileSnap['location']);
        await pref.setString('created', _profileSnap['created'].toString());
        await pref.setString(
            'lastUpdate', _profileSnap['lastUpdate'].toString());
      }

      return Profile(
          uid: uid,
          firstname: pref.getString('firstname'),
          lastname: pref.getString('lastname'),
          mobilePhone: pref.getString('mobilePhone'),
          page: Page(
              uid: uid,
              pageTitle: pref.getString('pageTitle'),
              pageDescription: pref.getString('pageDescription'),
              pageImageUrl: pref.getString('pageImageUrl'),
              created: pref.getString('created'),
              lastUpdate: pref.getString('lastUpdate')),
          location: pref.getString('location'),
          imageUrl: pref.getString('imageUrl'),
          created: pref.getString('created'),
          lastUpdate: pref.getString('lastUpdate'));
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Profile>> fetchProfiles() async {
    try {
      QuerySnapshot snapshot = await _profileService.fetchProfiles();
      final List<Profile> profiles = [];

      if (snapshot.documents.length == -1) return profiles;

      snapshot.documents.forEach((DocumentSnapshot snap) {
        final String uid = snap.documentID;

        profiles.add(
          Profile(
              uid: uid,
              firstname: snap['firstname'],
              lastname: snap['lastname'],
              mobilePhone: snap['mobilePhone'],
              page: Page(
                  uid: uid,
                  pageTitle: snap['pageTitle'],
                  pageDescription: snap['pageDescription'],
                  pageImageUrl: snap['pageImageUrl'],
                  created: snap['created'],
                  lastUpdate: snap['lastUpdate']),
              location: snap['location'],
              imageUrl: snap['imageUrl'],
              created: snap['created'],
              lastUpdate: snap['lastUpdate']),
        );
      });

      return profiles;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> createProfile(
      {@required String firstname,
      @required String lastname,
      @required String pageTitle,
      @required String pageDescription,
      @required String location}) async {
    try {
      final String uid = await _uid;
      final String username = await _username;

      await _profileService.createProfile(
          uid: uid,
          username: username,
          firstname: firstname,
          lastname: lastname,
          pageTitle: pageTitle,
          pageDescription: pageDescription,
          location: location);
    } catch (e) {
      throw (e);
    }
  }
}
