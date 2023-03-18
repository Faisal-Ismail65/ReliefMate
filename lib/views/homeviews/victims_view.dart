import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:reliefmate/utilities/widgets/profile_card.dart';

class VictimsView extends StatefulWidget {
  const VictimsView({super.key});

  @override
  State<VictimsView> createState() => _VictimsViewState();
}

class _VictimsViewState extends State<VictimsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('profiles')
              .where('type', isEqualTo: 'victim')
              .where('status', isEqualTo: 'approved')
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
                      return ProfileCard(
                        snap: snapshot.data!.docs[index].data(),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
