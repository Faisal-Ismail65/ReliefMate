import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/services/cloud/cloud_storage_exceptions.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final users = FirebaseFirestore.instance.collection('users');

  Future<String> createProfile({
    required String uid,
    required String email,
    required String name,
    required String cnic,
    required String phoneNumber,
    required String address,
  }) async {
    String res = 'Some Error Occured';

    try {
      UserProfile userProfile = UserProfile(
        uid: uid,
        email: email,
        name: name,
        cnic: cnic,
        phoneNumber: phoneNumber,
        address: address,
      );

      await _firestore.collection('users').doc(uid).set(userProfile.toJson());
      res = 'Success';
    } on CouldNotCreateUserProfileException {
      throw CouldNotCreateUserProfileException();
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
