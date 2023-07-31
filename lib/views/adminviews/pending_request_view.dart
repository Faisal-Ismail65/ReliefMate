import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/models/request.dart';
import 'package:reliefmate/utilities/widgets/donation_card.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/utilities/widgets/request_card.dart';

class PendingRequestView extends StatefulWidget {
  const PendingRequestView({super.key});

  @override
  State<PendingRequestView> createState() => _PendingRequestViewState();
}

class _PendingRequestViewState extends State<PendingRequestView> {
  List<Request> requestList = [];
  bool isLoading = false;

  @override
  void initState() {
    getRequestList();
    super.initState();
  }

  Future<void> getRequestList() async {
    setState(() {
      isLoading = true;
    });
    final snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .get();

    requestList = snapshot.docs.map((e) => Request.fromSnap(e)).toList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where('status', isEqualTo: 'pending')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final request =
                          Request.fromSnap(snapshot.data!.docs[index]);
                      // return Container();
                      return RequestCard(request: request);
                    },
                  );
                } else {
                  return const Loader();
                }
              default:
                return const Loader();
            }
          },
        ),
      ),
    );
  }
}
