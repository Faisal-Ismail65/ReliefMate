// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/profile/firestore_methods.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  var userData = {};
  void user() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(_userId)
        .get();
    userData = userSnap.data()!;
  }

  void deleteProfile() async {
    String res = await FirestoreMethods().deleteProfile(uid: _userId);
    if (res == 'Success') {
      showSnackBar(context, 'Profile is Deleted');
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BottomBarView(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'worksans',
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Column(children: [
        userData['status'] == 'approved'
            ? TextButton(
                onPressed: deleteProfile,
                child: const Text(
                  'Delete Profile',
                  style: TextStyle(color: Colors.red),
                ))
            : const SizedBox(),
      ]),
    );
  }
}
