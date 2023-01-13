import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/services/profile/cloud_storage_exceptions.dart';

import 'package:reliefmate/services/profile/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      await _firestore
          .collection('profiles')
          .doc(uid)
          .set(userProfile.toJson());
      res = 'Success';
    } on CouldNotCreateUserProfileException {
      throw CouldNotCreateUserProfileException();
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> updateProfile({
    required String uid,
    required String name,
    required String cnic,
    required String phoneNumber,
    required String address,
  }) async {
    String res = 'Some Error Occured';
    try {
      await _firestore.collection('profiles').doc(uid).update({
        'name': name,
        'cnic': cnic,
        'phoneNumber': phoneNumber,
        'address': address,
      });
      res = 'Success';
    } on CouldNotUpdateUserProfileException {
      throw CouldNotUpdateUserProfileException();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> uploadProfileImage({
    required Uint8List file,
    required String uid,
  }) async {
    String res = 'Some Error Occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('ProfilePics', file);

      await _firestore.collection('profilePics').doc(uid).set({
        'photoUrl': photoUrl,
      });
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
