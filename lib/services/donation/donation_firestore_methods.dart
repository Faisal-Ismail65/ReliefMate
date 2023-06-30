import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/models/donation.dart';
import 'package:uuid/uuid.dart';

class DonationFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createDonationa({
    required String donorid,
    required String donationAddress,
    required String donationMsg,
    required String donationExpDate,
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
      Donation donation = Donation(
          id: id,
          donorId: donorid,
          donationAddress: donationAddress,
          donationMsg: donationMsg,
          donationExpDate: donationExpDate,
          status: 'pending',
          createdAt: DateTime.now().toIso8601String());

      var category = {
        category1: description1,
        if (category2 != '') category2: description2,
        if (category3 != '') category3: description3,
      };

      await _firestore
          .collection('donations')
          .doc(id)
          .set(donation.toMap())
          .then((value) {
        _firestore
            .collection('donations')
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
