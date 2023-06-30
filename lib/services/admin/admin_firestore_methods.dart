import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFirestoreMethods {
  final FirebaseFirestore _adminfirestore = FirebaseFirestore.instance;

  Future<String> editProfile({
    required String uid,
    required String status,
  }) async {
    String res = 'Some Error Occured';
    try {
      await _adminfirestore.collection('profiles').doc(uid).update({
        'status': status,
      });
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> editRequest({
    required String uid,
    required String status,
    required String collectionName,
  }) async {
    String res = 'Some Error Occured';
    try {
      await _adminfirestore.collection(collectionName).doc(uid).update({
        'status': status,
      });
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
