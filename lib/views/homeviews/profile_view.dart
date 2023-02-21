// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliefmate/services/profile/firestore_methods.dart';
import 'package:reliefmate/utilities/utils/utils.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/homeviews/apply_for_relief.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  Uint8List? _image;
  var userData = {};
  var userProfile = {};
  bool isLoading = false;

  @override
  void initState() {
    getProfilePic();
    getData();
    super.initState();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    uploadProfileImage();
  }

  void uploadProfileImage() async {
    setState(() {
      isLoading = true;
    });
    String res = await FirestoreMethods().uploadProfileImage(
      file: _image!,
      uid: _userId,
    );
    setState(() {
      isLoading = false;
    });
    if (res == 'Success') {
      showSnackBar(context, 'Image is Uploaded Succesfully');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomBarView(),
      ));
    }
  }

  getProfilePic() async {
    setState(() {
      isLoading = true;
    });

    var userProfileSnap = await FirebaseFirestore.instance
        .collection('profilePics')
        .doc(_userId)
        .get();
    userProfile = userProfileSnap.data()!;

    setState(() {});
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(_userId)
          .get();

      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      print(e.toString());
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
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
                            child: userProfile['photoUrl'] != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userProfile['photoUrl']),
                                    radius: 200,
                                  )
                                : _image != null
                                    ? CircleAvatar(
                                        backgroundImage: MemoryImage(_image!),
                                        radius: 200,
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.redAccent,
                                      ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Colors.white,
                                ),
                                color: Colors.blue,
                              ),
                              child: InkWell(
                                onTap: selectImage,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    userData['name'] == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 30),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ApplyForRelief(),
                                    ),
                                  );
                                },
                                child: const Center(
                                  child: Text(
                                    'Create Profile',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )),
                          )
                        : userData['status'] == 'pending'
                            ? const Padding(
                                padding: EdgeInsets.only(
                                    left: 30, top: 40, bottom: 30),
                                child: Text(
                                  'Your Application is Submitted and Will be Reviewed',
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${userData['name'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${userData['email'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'CNIC',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${userData['cnic'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Phone No',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${userData['phoneNumber'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Address',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${userData['address'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Need',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${userData['need'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ],
                ),
              ),
            ),
          );
  }
}
