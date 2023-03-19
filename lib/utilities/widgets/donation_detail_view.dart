// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/profile_tile.dart';

class DonationDetailView extends StatefulWidget {
  final snap;
  const DonationDetailView({super.key, this.snap});

  @override
  State<DonationDetailView> createState() => _DonationDetailViewState();
}

class _DonationDetailViewState extends State<DonationDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: 'Donation Detail'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfileTile(
                fieldName: 'Address',
                fieldValue: widget.snap['donationAddress']),
            ProfileTile(
                fieldName: 'Donation Description',
                fieldValue: widget.snap['donationDesc']),
            ProfileTile(
                fieldName: 'Message', fieldValue: widget.snap['donationMsg']),
            ProfileTile(
                fieldName: 'Expiration Date',
                fieldValue: widget.snap['donationExpirationDate']),
          ],
        ),
      ),
    );
  }
}
