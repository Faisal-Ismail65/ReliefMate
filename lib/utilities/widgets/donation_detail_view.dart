// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reliefmate/models/donation.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/donation_detail_tile.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class DonationDetailView extends StatefulWidget {
  final Donation donation;
  const DonationDetailView({super.key, required this.donation});

  @override
  State<DonationDetailView> createState() => _DonationDetailViewState();
}

class _DonationDetailViewState extends State<DonationDetailView> {
  bool isLoading = false;
  var categories = {};
  UserProfile? user;

  void getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    final snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(widget.donation.donorId)
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
        .collection('donations')
        .doc(widget.donation.id)
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
      appBar: const SimpleAppBar(text: 'Donation Detail'),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  DonationDetailTile(
                    name: 'Donor Name',
                    value: user?.name ?? '',
                  ),
                  DonationDetailTile(
                    name: 'Donor Email',
                    value: user?.email ?? '',
                  ),
                  DonationDetailTile(
                    name: 'Donor Phone Number',
                    value: user?.phoneNumber ?? '',
                  ),
                  DonationDetailTile(
                    name: 'Donation Address',
                    value: widget.donation.donationAddress,
                  ),
                  if (widget.donation.donationMsg != '')
                    DonationDetailTile(
                      name: 'Donation Message',
                      value: widget.donation.donationMsg,
                    ),
                  DonationDetailTile(
                    name: 'Created At',
                    value: DateFormat('dd-MM-yyy')
                        .format(DateTime.parse(widget.donation.createdAt)),
                  ),
                  DonationDetailTile(
                    name: 'Expiration date',
                    value: widget.donation.donationExpDate,
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
                          name: 'Donation Categories',
                          value: categories.keys.join(', '),
                        ),
                  // DonationDetailTile(
                  //   name: 'Donor Email',
                  //   value: widget.snap['donorEmail'] ?? '',
                  // ),
                  // DonationDetailTile(
                  //   name: 'Donor Phone Number',
                  //   value: widget.snap['donorPhoneNumber'] ?? '',
                  // ),
                  // DonationDetailTile(
                  //   name: 'Address',
                  //   value: widget.snap['donationAddress'] ?? '',
                  // ),
                  // DonationDetailTile(
                  //     name: 'Message',
                  //     value: widget.snap['donationMsg'] == ''
                  //         ? 'No Message'
                  //         : widget.snap['donationMsg']),
                  // DonationDetailTile(
                  //     name: 'Expiration Date',
                  //     value: widget.snap['donationExpDate'] ?? 'not '),
                ],
              ),
            ),
    );
  }
}
