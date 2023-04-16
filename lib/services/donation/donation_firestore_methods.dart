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
    required String donationDesc,
    required String donationMsg,
    required String donationExpDate,
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
        donationDesc: donationDesc,
        donationMsg: donationMsg,
        donationExpDate: donationExpDate,
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
