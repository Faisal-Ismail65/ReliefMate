// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/profile/profile_firestore_methods.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    user();
    super.initState();
  }

  void user() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var userSnap = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(_userId)
        .get();
    userData = userSnap.data() ?? {};
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
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
      appBar: const SimpleAppBar(text: 'Settings'),
      body: ListView(
        children: [
          userData['status'] == 'approved'
              ? TextButton(
                  onPressed: deleteProfile,
                  child: const Text(
                    'Delete Profile',
                    style: TextStyle(color: Colors.red),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
