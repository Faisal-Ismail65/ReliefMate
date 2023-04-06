// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/donation_detail_tile.dart';

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
            DonationDetailTile(
              name: 'Address',
              value: widget.snap['donationAddress'],
            ),
            DonationDetailTile(
                name: 'Description', value: widget.snap['donationDesc']),
            DonationDetailTile(
                name: 'Message',
                value: widget.snap['donationMsg'] == ''
                    ? 'No Message'
                    : widget.snap['donationMsg']),
            DonationDetailTile(
                name: 'Expiration Date',
                value: widget.snap['donationExpirationDate']),
          ],
        ),
      ),
    );
  }
}
