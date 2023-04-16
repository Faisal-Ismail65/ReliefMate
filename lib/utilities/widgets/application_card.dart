// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/admin/admin_firestore_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/utilities/widgets/victim_detail.dart';

class ApplicationCard extends StatefulWidget {
  final snap;
  const ApplicationCard({super.key, this.snap});

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
        .doc(widget.snap['uid'])
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
            builder: (context) => VictimDetail(
              snap: widget.snap,
            ),
          ));
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: widget.snap['type'] == 'victim'
                    ? ListView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        children: [
                          widget.snap['status'] == 'pending'
                              ? 'Approve'
                              : 'Move to Pending List',
                          widget.snap['status'] == 'approved'
                              ? 'Block'
                              : 'Disapprove',
                        ]
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (e == 'Approve') {
                                        adminFirestoreMethods.editProfile(
                                          uid: widget.snap['uid'],
                                          status: 'approved',
                                        );
                                        showSnackBar(context,
                                            '${widget.snap['name']}\'s Profile is Approved');
                                      } else if (e == 'Move to Pending List') {
                                        adminFirestoreMethods.editProfile(
                                          uid: widget.snap['uid'],
                                          status: 'pending',
                                        );
                                        showSnackBar(context,
                                            '${widget.snap['name']}\'s Profile is moved to Pending List');
                                      } else if (e == 'Disapprove') {
                                        adminFirestoreMethods.editProfile(
                                          uid: widget.snap['uid'],
                                          status: 'disapproved',
                                        );
                                        showSnackBar(context,
                                            '${widget.snap['name']}\'s Profile is Disapproved');
                                      } else if (e == 'Block') {
                                        adminFirestoreMethods.editProfile(
                                          uid: widget.snap['uid'],
                                          status: 'blocked',
                                        );
                                        showSnackBar(context,
                                            '${widget.snap['name']}\'s Profile is Blocked');
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: GlobalVariables.appBarColor),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        children: [
                          widget.snap['status'] == 'approved'
                              ? 'Disapprove'
                              : 'Approve',
                        ]
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (e == 'Approve') {
                                        adminFirestoreMethods.editProfile(
                                          uid: widget.snap['uid'],
                                          status: 'approved',
                                        );
                                        showSnackBar(context,
                                            '${widget.snap['name']}\'s Profile is Approved');
                                      } else if (e == 'Disapprove') {
                                        adminFirestoreMethods.editProfile(
                                          uid: widget.snap['uid'],
                                          status: 'disapproved',
                                        );
                                        showSnackBar(context,
                                            '${widget.snap['name']}\'s Profile is Disapproved');
                                      } else if (e == 'Block') {
                                        adminFirestoreMethods.editProfile(
                                          uid: widget.snap['uid'],
                                          status: 'blocked',
                                        );
                                        showSnackBar(context,
                                            '${widget.snap['name']}\'s Profile is Blocked');
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: GlobalVariables.appBarColor),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              );
            },
          );
        },
        child: SizedBox(
          height: 100,
          child: Card(
            color: GlobalVariables.appBarBackgroundColor,
            elevation: 6,
            shadowColor: GlobalVariables.btnBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: userProfile['photoUrl'] == null
                        ? const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: GlobalVariables.btnBackgroundColor,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(userProfile['photoUrl']),
                          ),
                  ),
                  Container(
                    width: 220,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            ' Name : ${widget.snap['name']} ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Address :  ${widget.snap['address']} ',
                            style: const TextStyle(
                              color: Colors.white,
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
