// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reliefmate/models/donation.dart';
import 'package:reliefmate/providers/user_provider.dart';
import 'package:reliefmate/services/admin/admin_firestore_methods.dart';
import 'package:reliefmate/services/notification/send_notification_service.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reliefmate/utilities/widgets/donation_detail_view.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class DonationCard extends StatefulWidget {
  final Donation donation;
  const DonationCard({super.key, required this.donation});

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  final AdminFirestoreMethods adminFirestoreMethods = AdminFirestoreMethods();
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
    final user = Provider.of<UserProvider>(context).getUser;
    return InkWell(
      onTap: () {
        if (user.type == 'admin') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DonationDetailView(donation: widget.donation),
          ));
        }
      },
      onLongPress: () {
        if (user.type == 'admin' ||
            DateFormat('dd-MM-yyy')
                .parse(widget.donation.donationExpDate)
                .isAfter(DateTime.now())) {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
            context: context,
            builder: (context) {
              return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Change Donation Status',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.donation.status == 'pending'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                adminFirestoreMethods.editRequest(
                                  uid: widget.donation.id,
                                  status: 'pending',
                                  collectionName: 'donations',
                                );
                                showSnackBar(context,
                                    'Donation is Moved to Pending List');
                                SendNotificationService().sendNotificationToUser(
                                    userId: widget.donation.donorId,
                                    title: 'Donation Status',
                                    body:
                                        'Your Donation status is Changed to Pending.');
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Pending',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                      widget.donation.status == 'approved'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                adminFirestoreMethods.editRequest(
                                  uid: widget.donation.id,
                                  status: 'approved',
                                  collectionName: 'donations',
                                );
                                showSnackBar(context,
                                    'Donation is moved to Approved List');
                                SendNotificationService()
                                    .sendNotificationToUser(
                                  userId: widget.donation.donorId,
                                  title: 'Donation Status',
                                  body: 'Your Donation Status is Approved.',
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                      widget.donation.status == 'disapproved'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                adminFirestoreMethods.editRequest(
                                  uid: widget.donation.id,
                                  status: 'disapproved',
                                  collectionName: 'donations',
                                );
                                showSnackBar(context,
                                    'Donation is moved to Disapproved List');
                                SendNotificationService()
                                    .sendNotificationToUser(
                                  userId: widget.donation.donorId,
                                  title: 'Donation Status',
                                  body: 'Your Donation status is Disapproved',
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text('Disapprove',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          adminFirestoreMethods.editRequest(
                            uid: widget.donation.id,
                            status: 'completed',
                            collectionName: 'donations',
                          );
                          showSnackBar(
                              context, 'Donation is moved to Completed List');
                          SendNotificationService().sendNotificationToUser(
                              userId: widget.donation.donorId,
                              title: 'Request Status',
                              body: 'Your Request status is Completed');
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          );
        }
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
                        "End Date: ${widget.donation.donationExpDate}",
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
