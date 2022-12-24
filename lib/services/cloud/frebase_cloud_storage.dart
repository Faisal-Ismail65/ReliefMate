import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reliefmate/services/cloud/cloud_profile.dart';
import 'package:reliefmate/services/cloud/cloud_profile_constants.dart';

class FirebaseCloudStorage {
  final users = FirebaseFirestore.instance.collection('users');

  Stream<Iterable<CloudProfile>> getAllUsers() => users
      .snapshots()
      .map((event) => event.docs.map((doc) => CloudProfile.fromSnapshot(doc)));

  Future<CloudProfile> createProfile({
    required String userId,
    required String name,
    required String cnic,
    required String phoneNumber,
    required String address,
  }) async {
    final document = await users.add({
      userIdFieldName: userId,
      userNameFieldName: name,
      userCnicFieldName: cnic,
      userPhoneNumberFieldName: phoneNumber,
      userAddressFieldName: address
    });
    final user = await document.get();
    return CloudProfile(
      documentId: user.id,
      userId: userId,
      name: name,
      cnic: cnic,
      phoneNumber: phoneNumber,
      address: address,
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
