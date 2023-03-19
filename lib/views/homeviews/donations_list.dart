import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/donation_card.dart';

class DonationsList extends StatefulWidget {
  const DonationsList({super.key});

  @override
  State<DonationsList> createState() => _DonationsListState();
}

class _DonationsListState extends State<DonationsList> {
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: 'My Donations'),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('donations')
              .where('donorId', isEqualTo: _userId)
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
                      return DonationCard(
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
