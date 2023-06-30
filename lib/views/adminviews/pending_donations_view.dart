import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reliefmate/models/donation.dart';
import 'package:reliefmate/utilities/widgets/donation_card.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class PendingDonationView extends StatefulWidget {
  const PendingDonationView({super.key});

  @override
  State<PendingDonationView> createState() => _PendingDonationViewState();
}

class _PendingDonationViewState extends State<PendingDonationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('donations')
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
                      final donation =
                          Donation.fromMap(snapshot.data!.docs[index].data());
                      if (DateFormat('dd-MM-yyy')
                          .parse(donation.donationExpDate)
                          .isAfter(DateTime.now())) {
                        return DonationCard(donation: donation);
                      }
                      return const SizedBox();
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
