// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/victim_detail.dart';

class ProfileCard extends StatefulWidget {
  final snap;
  const ProfileCard({super.key, required this.snap});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
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
        isLoading = true;
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
        child: SizedBox(
          height: 100,
          child: Card(
            color: GlobalVariables.appBarBackgroundColor,
            elevation: 50,
            shadowColor: GlobalVariables.appBarColor,
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
                              color: GlobalVariables.appBarBackgroundColor,
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
