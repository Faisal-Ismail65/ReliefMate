// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Donation {
  String donorId;
  String donorEmail;
  String donorName;
  String donorCnic;
  String donorPhoneNumber;
  String donationAddress;
  String donationMsg;
  String donationExpDate;
  String status;
  String? category1;
  String? category2;
  String? category3;
  String? description1;
  String? description2;
  String? description3;
  Donation({
    required this.donorId,
    required this.donorEmail,
    required this.donorName,
    required this.donorCnic,
    required this.donorPhoneNumber,
    required this.donationAddress,
    required this.donationMsg,
    required this.donationExpDate,
    required this.status,
    this.category1,
    this.category2,
    this.category3,
    this.description1,
    this.description2,
    this.description3,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'donorId': donorId,
      'donorEmail': donorEmail,
      'donorName': donorName,
      'donorCnic': donorCnic,
      'donorPhoneNumber': donorPhoneNumber,
      'donationAddress': donationAddress,
      'donationMsg': donationMsg,
      'donationExpDate': donationExpDate,
      'status': status,
      'category1': category1,
      'category2': category2,
      'category3': category3,
      'description1': description1,
      'description2': description2,
      'description3': description3,
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
      donationMsg: map['donationMsg'] as String,
      donationExpDate: map['donationExpDate'] as String,
      status: map['status'] as String,
      category1: map['category1'] != null ? map['category1'] as String : null,
      category2: map['category2'] != null ? map['category2'] as String : null,
      category3: map['category3'] != null ? map['category3'] as String : null,
      description1:
          map['description1'] != null ? map['description1'] as String : null,
      description2:
          map['description2'] != null ? map['description2'] as String : null,
      description3:
          map['description3'] != null ? map['description3'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Donation.fromJson(String source) =>
      Donation.fromMap(json.decode(source) as Map<String, dynamic>);
}
