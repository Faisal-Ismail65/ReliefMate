import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reliefmate/models/request.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/views/homeviews/request_detail_view.dart';

class RequestCard extends StatefulWidget {
  final Request request;
  const RequestCard({super.key, required this.request});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool isLoading = false;
  var categories = {};

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
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                    widget.request.requestAddress,
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
                      // Text(
                      //   widget.request.donationExpDate,
                      //   style: GoogleFonts.lato(
                      //     textStyle:
                      //         TextStyle(fontSize: 13, color: Colors.grey[100]),
                      //   ),
                      // ),
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
                widget.request.status,
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
