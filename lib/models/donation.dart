// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Donation {
  String donorId;
  String donorEmail;
  String donorName;
  String donorCnic;
  String donorPhoneNumber;
  String donationAddress;
  String donationDesc;
  String donationMsg;
  String donationExpDate;
  String status;
  Donation({
    required this.donorId,
    required this.donorEmail,
    required this.donorName,
    required this.donorCnic,
    required this.donorPhoneNumber,
    required this.donationAddress,
    required this.donationDesc,
    required this.donationMsg,
    required this.donationExpDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'donorId': donorId,
      'donorEmail': donorEmail,
      'donorName': donorName,
      'donorCnic': donorCnic,
      'donorPhoneNumber': donorPhoneNumber,
      'donationAddress': donationAddress,
      'donationDesc': donationDesc,
      'donationMsg': donationMsg,
      'donationExpDate': donationExpDate,
      'status': status,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      donorId: map['donorId'] as String,
      donorEmail: map['donorEmail'] as String,
      donorName: map['donorName'] as String,
      donorCnic: map['donorCnic'] as String,
      donorPhoneNumber: map['donorPhoneNumber'] as String,
      donationAddress: map['donationAddress'] as String,
      donationDesc: map['donationDesc'] as String,
      donationMsg: map['donationMsg'] as String,
      donationExpDate: map['donationExpDate'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Donation.fromJson(String source) =>
      Donation.fromMap(json.decode(source) as Map<String, dynamic>);
}
