import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUser {
  final String uid;
  final String email;
  final String type;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'type': type,
      };

  static AuthUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AuthUser(
      uid: snapshot['uid'],
      email: snapshot['email'],
      type: snapshot['type'],
    );
  }
}
