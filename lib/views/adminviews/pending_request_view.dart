import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/widgets/donation_card.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class PendingRequestView extends StatefulWidget {
  const PendingRequestView({super.key});

  @override
  State<PendingRequestView> createState() => _PendingRequestViewState();
}

class _PendingRequestViewState extends State<PendingRequestView> {
  List requestList = [];
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
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .get();

    requestList = snapshot.docs.map((e) => e.data()).toList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                itemCount: requestList.length,
                itemBuilder: (context, index) {
                  return Container();
                },
              ),
            ),
    );
  }
}
