// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/services/admin/admin_firestore_methods.dart';
import 'package:reliefmate/services/notification/send_notification_service.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/utilities/widgets/profile_detail.dart';

class ApplicationCard extends StatefulWidget {
  final UserProfile user;
  const ApplicationCard({super.key, required this.user});

  @override
  State<ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<ApplicationCard> {
  final AdminFirestoreMethods adminFirestoreMethods = AdminFirestoreMethods();
  var userProfile = {};
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    var userProfileSnap = await FirebaseFirestore.instance
        .collection('profilePics')
        .doc(widget.user.uid)
        .get();

    userProfile = userProfileSnap.data() ?? {};
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileDetail(
              user: widget.user,
            ),
          ));
        },
        onLongPress: () {
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
                      'Change Profile Status',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    widget.user.status == 'pending' ||
                            widget.user.type == 'donor'
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              adminFirestoreMethods.editProfile(
                                uid: widget.user.uid,
                                status: 'pending',
                              );
                              showSnackBar(context,
                                  '${widget.user.name}\'s Profile is moved to Pending List');
                              SendNotificationService().sendNotificationToUser(
                                  userId: widget.user.uid,
                                  title: 'Profile Status',
                                  body:
                                      'Your Profile status is Changed to Pending.');
                              setState(() {});
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text('Pending',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                    widget.user.status == 'approved'
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              adminFirestoreMethods.editProfile(
                                uid: widget.user.uid,
                                status: 'approved',
                              );
                              showSnackBar(context,
                                  '${widget.user.name}\'s Profile is moved to Approved List');
                              SendNotificationService().sendNotificationToUser(
                                  userId: widget.user.uid,
                                  title: 'Profile Status',
                                  body: 'Your Profile is Approved.');
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text('Approve',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                            )),
                    widget.user.status == 'disapproved'
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              adminFirestoreMethods.editProfile(
                                uid: widget.user.uid,
                                status: 'disapproved',
                              );
                              showSnackBar(context,
                                  '${widget.user.name}\'s Profile is moved to Disapproved List');
                              SendNotificationService().sendNotificationToUser(
                                  userId: widget.user.uid,
                                  title: 'Profile Status',
                                  body: 'Your Profile status is Disapproved');
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
                        adminFirestoreMethods.editProfile(
                          uid: widget.user.uid,
                          status: 'blocked',
                        );
                        showSnackBar(context,
                            '${widget.user.name}\'s Profile is Blocked');
                        SendNotificationService().sendNotificationToUser(
                            userId: widget.user.uid,
                            title: 'Profile Status',
                            body: 'Your Profile status is Blocked');
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('Block',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: Card(
            // color: GlobalVariables.appBarBackgroundColor,
            elevation: 2,
            // shadowColor: GlobalVariables.appBarColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.width * 0.30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: userProfile['photoUrl'] == null
                        ? const CircleAvatar(
                            radius: 20,
                            backgroundColor: GlobalVariables.appBarColor,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: GlobalVariables.appBarBackgroundColor,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(userProfile['photoUrl']),
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: MediaQuery.of(context).size.height * 0.20,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.user.name,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.user.address,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
