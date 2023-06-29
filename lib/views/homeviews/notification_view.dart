import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/models/notification.dart' as notif;
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  void findAndReadNotifications() async {
    final documents = await FirebaseFirestore.instance
        .collection('notifications')
        .where('status', isEqualTo: 'unread')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var element in documents.docs) {
      batch.update(element.reference, {
        'status': 'read',
      });
    }
    await batch.commit();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    findAndReadNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        text: 'Notifications',
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notificationList = snapshot.data!.docs;
            if (notificationList.isEmpty) {
              return const Center(
                child: Text(
                  'No Notifications Right Now',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notif.Notification.fromMap(
                    snapshot.data!.docs[index].data());
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 5,
                          color: notification.status == 'read'
                              ? Colors.white
                              : GlobalVariables.appBarColor,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          notification.body,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          (DateTime.now()
                                      .difference(DateTime.parse(
                                          notification.createdAt))
                                      .inMilliseconds <
                                  1000
                              ? 'Now'
                              : DateTime.now()
                                          .difference(DateTime.parse(
                                              notification.createdAt))
                                          .inSeconds <
                                      60
                                  ? '${DateTime.now().difference(DateTime.parse(notification.createdAt)).inSeconds}s ago'
                                  : DateTime.now()
                                              .difference(DateTime.parse(
                                                  notification.createdAt))
                                              .inMinutes <
                                          60
                                      ? '${DateTime.now().difference(DateTime.parse(notification.createdAt)).inMinutes}m   ${DateTime.now().difference(DateTime.parse(notification.createdAt)).inSeconds % 60}s ago'
                                      : DateTime.now()
                                                  .difference(DateTime.parse(
                                                      notification.createdAt))
                                                  .inHours <
                                              24
                                          ? '${DateTime.now().difference(DateTime.parse(notification.createdAt)).inHours}h ${DateTime.now().difference(DateTime.parse(notification.createdAt)).inMinutes % 60}m ago'
                                          : '${DateTime.now().difference(DateTime.parse(notification.createdAt)).inDays}d ${DateTime.now().difference(DateTime.parse(notification.createdAt)).inHours % 24}h ago'),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Loader();
        },
      ),
      // body: FlutterMap(
      //   options: MapOptions(
      //     center: LatLng(37.4219991, -122.0840012), // London coordinates
      //     zoom: 18.0,
      //   ),
      //   children: [
      //     TileLayer(
      //       urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      //       subdomains: const ['a', 'b', 'c'],
      //     ),
      //     MarkerLayer(
      //       markers: [
      //         Marker(
      //           width: 40.0,
      //           height: 40.0,
      //           point: LatLng(37.4219991,
      //               -122.0840012), // Marker coordinates (same as map center in this example)
      //           builder: (ctx) => const Icon(
      //             Icons.location_on,
      //             size: 40,
      //             color: Colors.red,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
