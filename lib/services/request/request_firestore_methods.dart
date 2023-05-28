import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/models/request.dart';
import 'package:uuid/uuid.dart';

class RequestFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRequest({
    required String requesterId,
    required String requesterEmail,
    required String requesterName,
    required String requesterCnic,
    required String requesterPhoneNumber,
    required String requestAddress,
    required String requestMsg,
    required String category1,
    required String category2,
    required String category3,
    required String description1,
    required String description2,
    required String description3,
  }) async {
    String res = 'Some Error Occurred';
    try {
      final id = const Uuid().v4();
      Request request = Request(
        id: id,
        requesterId: requesterId,
        requesterEmail: requesterEmail,
        requesterName: requesterName,
        requesterCnic: requesterCnic,
        requesterPhoneNumber: requesterPhoneNumber,
        requestAddress: requestAddress,
        requestMsg: requestMsg,
        status: 'pending',
      );

      var category = {
        category1: description1,
        if (category2 != '') category2: description2,
        if (category3 != '') category3: description3,
      };

      await _firestore
          .collection('requests')
          .doc(id)
          .set(request.toMap())
          .then((value) {
        _firestore
            .collection('requests')
            .doc(id)
            .collection('category')
            .doc()
            .set(category)
            .then((value) {
          print('Done');
        });
      });

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
