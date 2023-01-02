// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliefmate/constants/routes.dart';
import 'package:reliefmate/services/auth/auth_service.dart';
import 'package:reliefmate/services/profile/firestore_methods.dart';
import 'package:reliefmate/utilities/utils/utils.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get _userId => AuthService.firebase().currentUser!.id;
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
    }
  }

  getProfilePic() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userProfileSnap = await FirebaseFirestore.instance
          .collection('profilePics')
          .doc(_userId)
          .get();
      userProfile = userProfileSnap.data()!;

      setState(() {});
    } catch (e) {
      print(e.toString());
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
                          TextButton(
                            onPressed: selectImage,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Name:  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.redAccent,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['name'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Email:  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.redAccent,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['email'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'PhoneNo:  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.redAccent,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['phoneNumber'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'CNIC:  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.redAccent,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['cnic'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Address:  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.redAccent,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['address'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
