// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliefmate/services/auth/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get _userEmail => AuthService.firebase().currentUser!.email;
  String get _userId => AuthService.firebase().currentUser!.id;

  File? _image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      print("failed to pick image $e");
    }
  }

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
                Column(
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
                      child: _image == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(_image!),
                              radius: 200,
                            ),
                    ),
                    TextButton(
                      onPressed: () => pickImage(),
                      child: const Text('Edit Image'),
                    ),
                  ],
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
