// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliefmate/services/profile/profile_firestore_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/utils/utils.dart';
import 'package:reliefmate/utilities/widgets/custom_text_button.dart';
import 'package:reliefmate/utilities/widgets/profile_tile.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/homeviews/create_profile.dart';
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
    if (mounted) {
      setState(() {
        _image = img;
      });
    }

    uploadProfileImage();
  }

  void uploadProfileImage() async {
    if (_image != null) {
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
  }

  getProfilePic() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    var userProfileSnap = await FirebaseFirestore.instance
        .collection('profilePics')
        .doc(_userId)
        .get();
    userProfile = userProfileSnap.data() ?? {};

    if (mounted) {
      setState(() {});
    }
  }

  getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(_userId)
          .get();

      userData = userSnap.data() ?? {};
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
                                color: GlobalVariables.appBarBackgroundColor,
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
                                        color: GlobalVariables
                                            .appBarBackgroundColor,
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
                                color: GlobalVariables.btnBackgroundColor,
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
                    userData['status'] == 'blocked'
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'Your Profile is Blocked',
                              ),
                            ),
                          )
                        : userData['status'] == 'disapproved'
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Text(
                                    'Your Application is Disapproved',
                                  ),
                                ),
                              )
                            : userData['status'] == 'pending'
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Text(
                                        'Your Application is Submitted and Will be Reviewed',
                                      ),
                                    ),
                                  )
                                : userData['name'] == null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 30),
                                        child: Center(
                                          child: CustomTextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CreateProfile(),
                                                ),
                                              );
                                            },
                                            text: "Create Profile",
                                            underline: false,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ProfileTile(
                                                fieldName: 'Name',
                                                fieldValue:
                                                    '${userData['name'] ?? ''}'),
                                            ProfileTile(
                                                fieldName: 'Email',
                                                fieldValue:
                                                    '${userData['email'] ?? ''}'),
                                            ProfileTile(
                                                fieldName: 'CNIC',
                                                fieldValue:
                                                    '${userData['cnic'] ?? ''}'),
                                            ProfileTile(
                                                fieldName: 'Phone No',
                                                fieldValue:
                                                    '${userData['phoneNumber'] ?? ''}'),
                                            ProfileTile(
                                                fieldName: 'Address',
                                                fieldValue:
                                                    '${userData['address'] ?? ''}'),
                                            userData['type'] == 'victim'
                                                ? Column(
                                                    children: [
                                                      ProfileTile(
                                                          fieldName:
                                                              'Account Number',
                                                          fieldValue:
                                                              '${userData['accountNumber'] ?? ''}'),
                                                      ProfileTile(
                                                          fieldName: 'Need',
                                                          fieldValue:
                                                              '${userData['need'] ?? ''}'),
                                                    ],
                                                  )
                                                : const SizedBox(),
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
