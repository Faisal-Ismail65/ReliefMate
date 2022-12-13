// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:reliefmate/services/auth/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get _userEmail => AuthService.firebase().currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Divider(
              color: Colors.redAccent,
              height: 50,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
