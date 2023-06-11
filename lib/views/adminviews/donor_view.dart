import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/views/adminviews/approved_donor_view.dart';
import 'package:reliefmate/views/adminviews/disapproved_donor_view.dart';

class DonorView extends StatelessWidget {
  const DonorView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Donors'),
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
                      text: 'Approved',
                    ),
                    Tab(
                      text: 'Disapproved',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              ApproveDonorView(),
              DisapprovedDonorView(),
            ],
          ),
        ));
  }
}
