// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Request {
  String id;
  String requesterId;
  String requestAddress;
  String requestMsg;
  String status;
  Request({
    required this.id,
    required this.requesterId,
    required this.requestAddress,
    required this.requestMsg,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'requesterId': requesterId,
      'requestAddress': requestAddress,
      'requestMsg': requestMsg,
      'status': status,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'] as String,
      requesterId: map['requesterId'] as String,
      requestAddress: map['requestAddress'] as String,
      requestMsg: map['requestMsg'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source) as Map<String, dynamic>);
}
