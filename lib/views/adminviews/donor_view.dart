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
            title: const Text('Victims'),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: GlobalVariables.appBarColor,
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
          body: const TabBarView(
            children: [
              ApproveDonorView(),
              DisapprovedDonorView(),
            ],
          ),
        ));
  }
}
