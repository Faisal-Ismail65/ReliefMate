import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String cnic;
  final String phoneNumber;
  final String address;
  final String type;
  final String status;
  final String token;
  final double latitude;
  final double longitude;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.cnic,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.type,
    required this.token,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'cnic': cnic,
        'phoneNumber': phoneNumber,
        'address': address,
        'status': status,
        'type': type,
        'longitude': longitude,
        'latitude': latitude,
        'token': token,
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
      status: snapshot['status'],
      type: snapshot['type'],
      token: snapshot['token'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
    );
  }
}
