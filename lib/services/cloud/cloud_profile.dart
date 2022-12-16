import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/services/cloud/cloud_profile_constants.dart';

class CloudProfile {
  final String documentId;
  final String userId;
  final String name;
  final String cnic;
  final String phoneNumber;
  final String address;

  const CloudProfile({
    required this.documentId,
    required this.userId,
    required this.name,
    required this.cnic,
    required this.phoneNumber,
    required this.address,
  });

  CloudProfile.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[userIdFieldName] as String,
        name = snapshot.data()[userNameFieldName] as String,
        cnic = snapshot.data()[userCnicFieldName] as String,
        phoneNumber = snapshot.data()[userPhoneNumberFieldName] as String,
        address = snapshot.data()[userAddressFieldName] as String;
}
