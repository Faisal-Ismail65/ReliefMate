// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    setState(() {
      isLoading = true;
    });
    var userProfileSnap = await FirebaseFirestore.instance
        .collection('profilePics')
        .doc(widget.snap['uid'])
        .get();

    userProfile = userProfileSnap.data()!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shrinkWrap: true,
                  children: [
                    'Name : ${widget.snap['name']}',
                    'Phone No : ${widget.snap['phoneNumber']}',
                    'Address : ${widget.snap['address']}',
                    'Need  : ${widget.snap['need']}'
                  ]
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
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
        child: Card(
          color: Colors.redAccent,
          elevation: 50,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: userProfile['photoUrl'] == null
                      ? const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.redAccent,
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
    );
  }
}
