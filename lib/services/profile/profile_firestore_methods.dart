import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/services/profile/cloud_storage_exceptions.dart';

import 'package:reliefmate/services/profile/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserProfile> getUserProfileDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('profiles').doc(currentUser.uid).get();
    return UserProfile.fromSnap(snapshot);
  }

  Future<String> createProfile({
    required String uid,
    required String email,
    required String name,
    required String cnic,
    required String phoneNumber,
    required String address,
    required String need,
    required String type,
    required String accountNumber,
  }) async {
    String res = 'Some Error Occured';

    try {
      if (type == 'donor') {
        UserProfile userProfile = UserProfile(
          uid: uid,
          email: email,
          name: name,
          cnic: cnic,
          phoneNumber: phoneNumber,
          address: address,
          status: 'approved',
          type: type,
        );
        await _firestore
            .collection('profiles')
            .doc(uid)
            .set(userProfile.toJson());
      } else if (type == 'victim') {
        UserProfile userProfile = UserProfile(
          uid: uid,
          email: email,
          name: name,
          cnic: cnic,
          phoneNumber: phoneNumber,
          address: address,
          status: 'pending',
          type: type,
          need: need,
          accountNumber: accountNumber,
        );
        await _firestore
            .collection('profiles')
            .doc(uid)
            .set(userProfile.toJson());
      }

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
    required String need,
    required String accountNumber,
  }) async {
    String res = 'Some Error Occured';
    try {
      await _firestore.collection('profiles').doc(uid).update({
        'name': name,
        'cnic': cnic,
        'phoneNumber': phoneNumber,
        'address': address,
        'need': need,
        'accountNumber': accountNumber,
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

      await _firestore.collection('profiles').doc(uid).update({
        'imageUrl': photoUrl,
      });
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteProfile({required String uid}) async {
    String res = 'Some error occured';
    try {
      await _firestore.collection('profiles').doc(uid).delete();
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
