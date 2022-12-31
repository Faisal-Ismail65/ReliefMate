// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliefmate/constants/routes.dart';
import 'package:reliefmate/services/auth/auth_service.dart';
import 'package:reliefmate/services/cloud/frebase_cloud_storage.dart';
import 'package:reliefmate/services/profile/firestore_methods.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class ApplyForRelief extends StatefulWidget {
  const ApplyForRelief({super.key});

  @override
  State<ApplyForRelief> createState() => _ApplyForReliefState();
}

class _ApplyForReliefState extends State<ApplyForRelief> {
  // File? _image;
  late final FirebaseCloudStorage _cloudService;
  late final TextEditingController _name;
  late final TextEditingController _cnic;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _address;
  String get _userEmail => AuthService.firebase().currentUser!.email;
  String get _userId => AuthService.firebase().currentUser!.id;
  final _user = AuthService.firebase().currentUser;

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //     File? img = File(image.path);
  //     setState(() {
  //       _image = img;
  //     });
  //   } on PlatformException catch (e) {
  //     print("failed to pick image $e");
  //   }
  // }
  void createProfile() async {
    String res = await FirestoreMethods().createProfile(
      uid: _userId,
      email: _userEmail,
      name: _name.text,
      cnic: _cnic.text,
      phoneNumber: _phoneNumber.text,
      address: _address.text,
    );

    if (res == 'Success') {
      Navigator.of(context).pop();
      showSnackBar(context, 'Your Profile Is Created Succesfully');
    }
  }

  @override
  void initState() {
    _cloudService = FirebaseCloudStorage();
    _name = TextEditingController();
    _cnic = TextEditingController();
    _phoneNumber = TextEditingController();
    _address = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _cnic.dispose();
    _phoneNumber.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Create Profile',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'worksans',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: createProfile,
            // () async {
            //   final userId = AuthService.firebase().currentUser!.id;
            //   final name = _name.text;
            //   final cnic = _cnic.text;
            //   final phoneNumber = _phoneNumber.text;
            //   final address = _address.text;
            //   await _cloudService.createProfile(
            //     userId: userId,
            //     name: name,
            //     cnic: cnic,
            //     phoneNumber: phoneNumber,
            //     address: address,
            //   );
            //   Navigator.of(context).pop();
            // },
            icon: const Icon(
              Icons.done,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Center(
              //   child: Container(
              //     width: 130,
              //     height: 130,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Colors.black,
              //         width: 2,
              //       ),
              //       shape: BoxShape.circle,
              //     ),
              //     child: _image == null
              //         ? const Icon(
              //             Icons.person,
              //             size: 50,
              //           )
              //         : CircleAvatar(
              //             backgroundImage: FileImage(_image!),
              //             radius: 200,
              //           ),
              //   ),
              // ),
              // Center(
              //   child: TextButton(
              //     onPressed: () => pickImage(),
              //     child: const Text('Edit Image'),
              //   ),
              // ),
              TextFormField(
                controller: _name,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Enter Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _cnic,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Enter CNIC',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _phoneNumber,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _address,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Enter Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
