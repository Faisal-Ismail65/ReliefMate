import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notification {
  final String id;
  final String title;
  final String body;
  final String userId;
  final String createdAt;
  final String status;
  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'createdAt': createdAt,
      'status': status,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      userId: map['userId'] as String,
      createdAt: map['createdAt'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);
}
