import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:reliefmate/models/request.dart';
import 'package:reliefmate/providers/user_provider.dart';
import 'package:reliefmate/services/admin/admin_firestore_methods.dart';
import 'package:reliefmate/services/notification/send_notification_service.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class RequestCard extends StatefulWidget {
  final Request request;
  const RequestCard({super.key, required this.request});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  final AdminFirestoreMethods adminFirestoreMethods = AdminFirestoreMethods();
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
    final user = Provider.of<UserProvider>(context).getUser;
    return InkWell(
      onLongPress: () {
        if (user.type == 'admin') {
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
                        'Change Request Status',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.request.status == 'pending'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                adminFirestoreMethods.editRequest(
                                  uid: widget.request.id,
                                  status: 'pending',
                                  collectionName: 'requests',
                                );
                                showSnackBar(context,
                                    'Request is Moved to Pending List');
                                SendNotificationService().sendNotificationToUser(
                                    userId: widget.request.requesterId,
                                    title: 'Request Status',
                                    body:
                                        'Your Request status is Changed to Pending.');
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
                      widget.request.status == 'approved'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                adminFirestoreMethods.editRequest(
                                  uid: widget.request.id,
                                  status: 'approved',
                                  collectionName: 'requests',
                                );
                                showSnackBar(context,
                                    'Request is moved to Approved List');
                                SendNotificationService()
                                    .sendNotificationToUser(
                                  userId: widget.request.requesterId,
                                  title: 'Request Status',
                                  body: 'Your Request Status is Approved.',
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
                      widget.request.status == 'disapproved'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                adminFirestoreMethods.editRequest(
                                  uid: widget.request.id,
                                  status: 'disapproved',
                                  collectionName: 'requests',
                                );
                                showSnackBar(context,
                                    'Request is moved to Disapproved List');
                                SendNotificationService()
                                    .sendNotificationToUser(
                                  userId: widget.request.requesterId,
                                  title: 'Request Status',
                                  body: 'Your Request status is Disapproved',
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
                            uid: widget.request.id,
                            status: 'completed',
                            collectionName: 'requests',
                          );
                          showSnackBar(
                              context, 'Request is moved to Completed List');
                          SendNotificationService().sendNotificationToUser(
                              userId: widget.request.requesterId,
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
                      Text(
                        DateFormat('dd-MM-yyy')
                            .format(DateTime.parse(widget.request.createdAt)),
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
