import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/utilities/widgets/application_card.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class DisapprovedVictimsView extends StatelessWidget {
  const DisapprovedVictimsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('profiles')
              .where('status', isEqualTo: 'disapproved')
              .where('type', isEqualTo: 'victim')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final user =
                          UserProfile.fromSnap(snapshot.data!.docs[index]);
                      return ApplicationCard(
                        user: user,
                      );
                    },
                  );
                } else {
                  return const Loader();
                }
              default:
                return const Loader();
            }
          },
        ),
      ),
    );
  }
}
