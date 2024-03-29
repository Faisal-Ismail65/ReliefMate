import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reliefmate/models/donation.dart';
import 'package:reliefmate/utilities/widgets/donation_card.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class ExpiredDonationView extends StatefulWidget {
  const ExpiredDonationView({super.key});

  @override
  State<ExpiredDonationView> createState() => _ExpiredDonationViewState();
}

class _ExpiredDonationViewState extends State<ExpiredDonationView> {
  List<Donation> donationList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDonationList();
  }

  Future<void> getDonationList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('donations')
        .where('status', isEqualTo: 'pending')
        .get();

    donationList =
        snapshot.docs.map((e) => Donation.fromMap(e.data())).toList();

    setState(() {
      isLoading = false;
    });
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
                          .isBefore(DateTime.now())) {
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
