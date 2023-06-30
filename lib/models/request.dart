// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String id;
  String requesterId;
  String requestAddress;
  String requestMsg;
  String status;
  String createdAt;
  Request({
    required this.id,
    required this.requesterId,
    required this.requestAddress,
    required this.requestMsg,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'requesterId': requesterId,
      'requestAddress': requestAddress,
      'requestMsg': requestMsg,
      'status': status,
      'createdAt': createdAt,
    };
  }

  static Request fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Request(
      id: snapshot['id'] as String,
      requesterId: snapshot['requesterId'] as String,
      requestAddress: snapshot['requestAddress'] as String,
      requestMsg: snapshot['requestMsg'] as String,
      status: snapshot['status'] as String,
      createdAt: snapshot['createdAt'] as String,
    );
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'] as String,
      requesterId: map['requesterId'] as String,
      requestAddress: map['requestAddress'] as String,
      requestMsg: map['requestMsg'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source) as Map<String, dynamic>);
}
