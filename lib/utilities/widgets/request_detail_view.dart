// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reliefmate/models/request.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/donation_detail_tile.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class RequestDetailView extends StatefulWidget {
  final Request request;
  const RequestDetailView({super.key, required this.request});

  @override
  State<RequestDetailView> createState() => _RequestDetailViewState();
}

class _RequestDetailViewState extends State<RequestDetailView> {
  bool isLoading = false;
  var categories = {};
  UserProfile? user;

  void getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    final snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(widget.request.requesterId)
        .get();

    user = UserProfile.fromSnap(snapshot);
    setState(() {
      isLoading = false;
    });
  }

  void getCategories() async {
    setState(() {
      isLoading = true;
    });
    final categorySnap = await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.request.id)
        .collection('category')
        .get();

    categories = categorySnap.docs.first.data();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: 'Request Detail'),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  DonationDetailTile(
                    name: 'Requester Name',
                    value: user?.name ?? '',
                  ),
                  DonationDetailTile(
                    name: 'Requester Email',
                    value: user?.email ?? '',
                  ),
                  DonationDetailTile(
                    name: 'Requester Phone Number',
                    value: user?.phoneNumber ?? '',
                  ),
                  DonationDetailTile(
                    name: 'Request Address',
                    value: widget.request.requestAddress,
                  ),
                  if (widget.request.requestMsg != '')
                    DonationDetailTile(
                      name: 'Donation Message',
                      value: widget.request.requestMsg,
                    ),
                  DonationDetailTile(
                    name: 'Created At',
                    value: DateFormat('dd-MM-yyy')
                        .format(DateTime.parse(widget.request.createdAt)),
                  ),
                  isLoading
                      ? SizedBox(
                          height: 18,
                          child: LoadingAnimationWidget.waveDots(
                            color: Colors.black,
                            size: 18,
                          ),
                        )
                      : DonationDetailTile(
                          name: 'Request Categories',
                          value: categories.keys.join(', '),
                        ),
                ],
              ),
            ),
    );
  }
}
