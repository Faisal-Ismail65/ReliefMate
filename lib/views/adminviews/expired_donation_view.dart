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
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                itemCount: donationList.length,
                itemBuilder: (context, index) {
                  DateTime date = DateFormat('dd-MM-yyy')
                      .parse(donationList[index].donationExpDate);
                  if (date.isBefore(DateTime.now())) {
                    return DonationCard(donation: donationList[index]);
                  }
                  return const SizedBox();
                },
              )),
    );
  }
}
