import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/models/donation.dart';

class DonationFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> createDonationa({
    required String donorid,
    required String donorEmail,
    required String donorName,
    required String donorCnic,
    required String donorPhoneNumber,
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
      Donation donation = Donation(
        donorId: donorid,
        donorEmail: donorEmail,
        donorName: donorName,
        donorCnic: donorCnic,
        donorPhoneNumber: donorPhoneNumber,
        donationAddress: donationAddress,
        donationMsg: donationMsg,
        donationExpDate: donationExpDate,
        category1: category1,
        category2: category2,
        category3: category3,
        description1: description1,
        description2: description2,
        description3: description3,
        status: 'pending',
      );
      await _firestore.collection('donations').doc().set(donation.toMap());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
