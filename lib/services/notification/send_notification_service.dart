import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/models/auth_user.dart';
import 'package:http/http.dart' show post;
import 'package:reliefmate/models/notification.dart';
import 'package:uuid/uuid.dart';

class SendNotificationService {
  Future<String> getServerKey() async {
    final snap =
        await FirebaseFirestore.instance.collection('fcm').doc('key').get();

    final doc = snap.data();
    return doc!['key'];
  }

  Future<AuthUser> getUserById({
    required String id,
  }) async {
    final userSnap =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return AuthUser.fromSnap(userSnap);
  }

  void sendNoticationToAdmin({
    required String title,
    required String body,
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'admin')
        .limit(1)
        .get();

    AuthUser admin = AuthUser.fromSnap(snapshot.docs[0]);

    final serverKey = await getServerKey();
    final notificationBody = {
      'to': admin.token,
      'notification': {
        'title': title,
        'body': body,
        'android_channel_id': 'reliefmate',
      },
    };
    var res = await post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'key=$serverKey'
      },
      body: jsonEncode(notificationBody),
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      final id = const Uuid().v4();

      final notification = Notification(
        id: id,
        title: title,
        body: body,
        userId: admin.uid,
        createdAt: DateTime.now().toIso8601String(),
        status: 'unread',
      );

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notification.toMap());
    }
  }

  void sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    final user = await getUserById(id: userId);
    final serverKey = await getServerKey();
    final notificationBody = {
      'to': user.token,
      'notification': {
        'title': title,
        'body': body,
        'android_channel_id': 'reliefmate',
      },
    };
    var res = await post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'key=$serverKey'
      },
      body: jsonEncode(notificationBody),
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      final id = const Uuid().v4();

      final notification = Notification(
        id: id,
        title: title,
        body: body,
        userId: userId,
        createdAt: DateTime.now().toIso8601String(),
        status: 'unread',
      );

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notification.toMap());
    }
  }
}
