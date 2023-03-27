// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/profile/profile_firestore_methods.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class EditProfile extends StatefulWidget {
  final userData;
  const EditProfile({super.key, required this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  String? type;
  final _editProfileKey = GlobalKey<FormState>();
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;
  String? category;
  List<String> needs = [
    'Edibles',
    'Wearables',
    'Residence',
    'Medicine',
  ];

  @override
  void initState() {
    _nameController.text = widget.userData['name'];
    _cnicController.text = widget.userData['cnic'];
    _phoneNumberController.text = widget.userData['phoneNumber'];
    _addressController.text = widget.userData['address'];
    _accountNumberController.text = widget.userData['accountNumber'] ?? '';
    category = widget.userData['need'] ?? '';
    type = widget.userData['type'];

    super.initState();
  }

  void editProfile() async {
    bool isForm = _nameController.text.isNotEmpty &&
        _cnicController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _addressController.text.isNotEmpty;
    if (isForm) {
      if (_editProfileKey.currentState!.validate()) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }

        String res = await FirestoreMethods().updateProfile(
          uid: _userId,
          name: _nameController.text,
          cnic: _cnicController.text,
          phoneNumber: _phoneNumberController.text,
          address: _addressController.text,
          need: category ?? '',
          accountNumber: _accountNumberController.text,
        );
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        if (res == 'Success') {
          Navigator.of(context).pop();
          showSnackBar(context, 'Your Profile Is Updated Succesfully');
        }
      }
    } else {
      showSnackBar(context, "Please fill all fields!");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : Scaffold(
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
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'worksans',
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              actions: [
                IconButton(
                  onPressed: editProfile,
                  icon: const Icon(
                    Icons.done,
                    size: 30,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _editProfileKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        labelText: "Enter Name",
                        obseureText: false,
                      ),
                      CustomTextField(
                        controller: _cnicController,
                        labelText: 'Enter CNIC',
                        obseureText: false,
                      ),
                      CustomTextField(
                        controller: _phoneNumberController,
                        labelText: 'Enter Phone NUmber',
                        obseureText: false,
                      ),
                      CustomTextField(
                        controller: _addressController,
                        labelText: 'Enter Address',
                        obseureText: false,
                      ),
                      type == 'victim'
                          ? Column(
                              children: [
                                CustomTextField(
                                  controller: _accountNumberController,
                                  labelText: 'Enter Account Number',
                                  obseureText: false,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: DropdownButtonFormField(
                                    value: category,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    iconSize: 20,
                                    hint: const Text(
                                      'Need',
                                    ),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    onChanged: (value) {
                                      setState(() {
                                        category = value.toString();
                                      });
                                    },
                                    items: needs.map((String item) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.center,
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
