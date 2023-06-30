import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/views/adminviews/approved_request_view.dart';
import 'package:reliefmate/views/adminviews/completed_request_view.dart';
import 'package:reliefmate/views/adminviews/disapproved_request_view.dart';
import 'package:reliefmate/views/adminviews/pending_request_view.dart';

class RequestView extends StatelessWidget {
  const RequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Requests'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 40),
              child: Container(
                height: kToolbarHeight + 8.0,
                padding:
                    const EdgeInsets.only(top: 16.0, right: 5.0, left: 5.0),
                decoration: const BoxDecoration(
                  color: GlobalVariables.appBarColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                ),
                child: const TabBar(
                  isScrollable: true,
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
                      text: 'Approved',
                    ),
                    Tab(
                      text: 'Completed',
                    ),
                    Tab(
                      text: 'Disapproved',
                    )
                  ],
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              PendingRequestView(),
              ApprovedRequestView(),
              CompletedRequestView(),
              DisapprovedRequestView(),
            ],
          ),
        ));
  }
}
