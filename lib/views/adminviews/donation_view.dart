import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/views/adminviews/completed_donation_view.dart';
import 'package:reliefmate/views/adminviews/expired_donation_view.dart';
import 'package:reliefmate/views/adminviews/pending_donations_view.dart';

class DonationView extends StatelessWidget {
  const DonationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Donations'),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: GlobalVariables.appBarColor,
              tabs: [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'Completed',
                ),
                Tab(
                  text: 'Expired',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              PendingDonationView(),
              CompletedDonationView(),
              ExpiredDonationView(),
            ],
          ),
        ));
  }
}
