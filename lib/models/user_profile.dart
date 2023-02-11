import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String cnic;
  final String phoneNumber;
  final String address;
  final String need;
  final String status;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.cnic,
    required this.phoneNumber,
    required this.address,
    required this.need,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'cnic': cnic,
        'phoneNumber': phoneNumber,
        'address': address,
        'need': need,
        'status': status,
      };

  static UserProfile fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserProfile(
      uid: snapshot['uid'],
      email: snapshot['email'],
      name: snapshot['name'],
      cnic: snapshot['cnic'],
      phoneNumber: snapshot['phoneNumber'],
      address: snapshot['address'],
      need: snapshot['need'],
      status: snapshot['status'],
    );
  }
}
