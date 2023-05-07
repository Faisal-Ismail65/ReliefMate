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
  List donationList = [];
  bool isLoading = false;

  @override
  void initState() {
    getDonationList();
    super.initState();
  }

  Future<void> getDonationList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('donations')
        .where('status', isEqualTo: 'pending')
        .get();

    donationList = snapshot.docs.map((e) => e.data()).toList();
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
                      .parse(donationList[index]['donationExpDate']);
                  if (date.isAfter(DateTime.now())) {
                    return DonationCard(
                      snap: donationList[index],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
    );
  }
}
