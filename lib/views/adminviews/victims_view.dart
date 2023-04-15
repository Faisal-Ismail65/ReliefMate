import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/views/adminviews/approved_victims_view.dart';
import 'package:reliefmate/views/adminviews/disapproved_victims_view.dart';
import 'package:reliefmate/views/adminviews/pending_victims_view.dart';

class VictimsView extends StatelessWidget {
  const VictimsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                  text: 'Pending',
                ),
                Tab(
                  text: 'Disapproved',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ApprovedVictimsView(),
              PendingVictimsView(),
              DisapprovedVictimsView(),
            ],
          ),
        ));
  }
}
