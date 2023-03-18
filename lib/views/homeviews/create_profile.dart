// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/profile/firestore_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final _userEmail = FirebaseAuth.instance.currentUser!.email;
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  int? _value;
  final _profileKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? category;
  List<String> needs = [
    'Edibles',
    'Wearables',
    'Residence',
    'Medicine',
  ];
  void createProfile() async {
    bool isForm = _nameController.text.isNotEmpty &&
        _cnicController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _value != null;

    if (isForm) {
      if (_profileKey.currentState!.validate()) {
        if (_value == 0) {
          if (mounted) {
            setState(() {
              isLoading = true;
            });
          }
          String res = await FirestoreMethods().createProfile(
            uid: _userId,
            email: _userEmail!,
            name: _nameController.text,
            cnic: _cnicController.text,
            phoneNumber: _phoneNumberController.text,
            address: _addressController.text,
            type: 'donor',
            accountNumber: _accountNumberController.text,
            need: category ?? '',
          );
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          if (res == 'Success') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const BottomBarView(),
            ));
            showSnackBar(context, 'Your Profile Is Created Succesfully');
          }
        } else if (_value == 1) {
          if (_accountNumberController.text != '' && category != null) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
            String res = await FirestoreMethods().createProfile(
              uid: _userId,
              email: _userEmail!,
              name: _nameController.text,
              cnic: _cnicController.text,
              phoneNumber: _phoneNumberController.text,
              address: _addressController.text,
              type: 'victim',
              accountNumber: _accountNumberController.text,
              need: category!,
            );
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            if (res == 'Success') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const BottomBarView(),
              ));
              showSnackBar(context, 'Your Profile Is Created Succesfully');
            }
          } else {
            showSnackBar(context, "Please fill all fields!");
          }
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
        ? const Center(
            child: CircularProgressIndicator(),
          )
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
                'Create Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'worksans',
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              actions: [
                IconButton(
                  onPressed: createProfile,
                  icon: const Icon(
                    Icons.done,
                    size: 30,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _profileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      RadioListTile(
                        activeColor: GlobalVariables.btnBackgroundColor,
                        title: const Text(
                          'Donor',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        value: 0,
                        groupValue: _value,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _value = value!;
                            });
                          }
                        },
                      ),
                      RadioListTile(
                        activeColor: GlobalVariables.btnBackgroundColor,
                        title: const Text(
                          'Victim',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        value: 1,
                        groupValue: _value,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _value = value!;
                            });
                          }
                        },
                      ),
                      _value == 1
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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    hint: const Text(
                                      'Need',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    onChanged: (value) {
                                      setState(() {
                                        category = value!;
                                      });
                                    },
                                    items: needs.map((String item) {
                                      return DropdownMenuItem(
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
