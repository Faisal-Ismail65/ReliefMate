// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliefmate/models/donation.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reliefmate/utilities/widgets/donation_detail_view.dart';

class DonationCard extends StatefulWidget {
  final Donation donation;
  const DonationCard({super.key, required this.donation});

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  bool isLoading = false;
  var categories = {};

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
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DonationDetailView(donation: widget.donation),
        // ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: GlobalVariables.appBarColor),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.donation.donationAddress,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.donation.donationExpDate,
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 13, color: Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  isLoading
                      ? SizedBox(
                          height: 18,
                          child: LoadingAnimationWidget.waveDots(
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Text(
                          categories.keys.join(', '),
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[100],
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                widget.donation.status,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
