import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/donation_detail_tile.dart';

class RequestDetailView extends StatelessWidget {
  final snap;
  const RequestDetailView({super.key, this.snap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: 'Request Detail'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            DonationDetailTile(
              name: 'Address',
              value: snap['requestAddress'] ?? '',
            ),
            DonationDetailTile(
                name: 'Message',
                value: snap['requestMsg'] == ''
                    ? 'No Message'
                    : snap['requestMsg']),
          ],
        ),
      ),
    );
  }
}
