import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/widgets/application_card.dart';

class PendingApplicationsView extends StatefulWidget {
  const PendingApplicationsView({super.key});

  @override
  State<PendingApplicationsView> createState() =>
      _PendingApplicationsViewState();
}

class _PendingApplicationsViewState extends State<PendingApplicationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('profiles')
              .where('status', isEqualTo: 'pending')
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
                      return ApplicationCard(
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
