// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliefmate/main.dart';
import 'package:reliefmate/services/auth/auth_service.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get _userId => AuthService.firebase().currentUser!.id;
  var userData = {};
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

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

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();
      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                    ],
                  ),
                  const Divider(
                    color: Colors.redAccent,
                    height: 50,
                    thickness: 2,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ' Name: ${userData['name']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.redAccent),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email: ${userData['email']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.redAccent),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'CNIC: ${userData['cnic']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.redAccent),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Address: ${userData['address']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
