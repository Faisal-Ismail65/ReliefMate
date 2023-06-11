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
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 40),
              child: Container(
                height: kToolbarHeight + 8.0,
                padding:
                    const EdgeInsets.only(top: 16.0, right: 20.0, left: 20.0),
                decoration: const BoxDecoration(
                  color: GlobalVariables.appBarColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                ),
                child: const TabBar(
                  indicatorColor: GlobalVariables.appBarColor,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      color: Colors.white),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
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
