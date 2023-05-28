// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/request/request_firestore_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/custom_elevated_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  final TextEditingController _descriptionController1 = TextEditingController();
  final TextEditingController _descriptionController2 = TextEditingController();
  final TextEditingController _descriptionController3 = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final _donationKey = GlobalKey<FormState>();
  var userData = {};
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  String category1 = '';
  String category2 = '';
  String category3 = '';
  List<String> needs = [
    'Edibles',
    'Wearables',
    'Residence',
    'Medicine',
    'Other',
  ];
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  int index = 0;

  @override
  void initState() {
    super.initState();
    getData();
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

  void createRequest() async {
    bool isForm = _addressController.text.isNotEmpty &&
        _descriptionController1.text.isNotEmpty;
    if (isForm) {
      if (_donationKey.currentState!.validate()) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }

        String res = await RequestFirestoreMethods().createRequest(
          requesterId: userData['uid'],
          requesterEmail: userData['email'],
          requesterName: userData['name'],
          requesterCnic: userData['cnic'],
          requesterPhoneNumber: userData['phoneNumber'],
          requestAddress: _addressController.text,
          category1: category1,
          category2: category2,
          category3: category3,
          description1: _descriptionController1.text,
          description2: _descriptionController2.text,
          description3: _descriptionController3.text,
          requestMsg: _messageController.text,
        );
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        if (res == 'Success') {
          Navigator.of(context).pop();
          showSnackBar(context, 'Requested Succesfully');
        }
      }
    } else {
      showSnackBar(context, "Please fill all fields!");
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController1.dispose();
    _descriptionController2.dispose();
    _descriptionController3.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: "Request"),
      body: isLoading
          ? const Loader()
          : ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Form(
                      key: _donationKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _addressController,
                            labelText: 'Enter Address',
                            obseureText: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, bottom: 10, right: 15),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          GlobalVariables.btnBackgroundColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: GlobalVariables.btnBackgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              iconSize: 20,
                              hint: const Text(
                                'Request Category',
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onChanged: (value) {
                                category1 = value!;
                                setState(() {
                                  index++;
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
                          Visibility(
                            visible: index > 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                minLines: 3,
                                maxLines: 3,
                                controller: _descriptionController1,
                                decoration: InputDecoration(
                                  hintText: 'Enter Products Description',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: index > 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                iconSize: 20,
                                hint: const Text(
                                  'Optional Second Category',
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onChanged: (value) {
                                  category2 = value!;
                                  setState(() {
                                    index++;
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
                          ),
                          Visibility(
                            visible: index > 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                minLines: 3,
                                maxLines: 3,
                                controller: _descriptionController2,
                                decoration: InputDecoration(
                                  hintText: 'Enter Products Description',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: index > 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                iconSize: 20,
                                hint: const Text(
                                  'Optional Third Category',
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onChanged: (value) {
                                  category3 = value!;
                                  setState(() {
                                    index++;
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: index > 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                minLines: 3,
                                maxLines: 3,
                                controller: _descriptionController3,
                                decoration: InputDecoration(
                                  hintText: 'Enter Products Description',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              minLines: 3,
                              maxLines: 3,
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Optional Message',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          GlobalVariables.btnBackgroundColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: GlobalVariables.btnBackgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          CustomElevatedButton(
                              onPressed: createRequest, text: "Request")
                        ],
                      ),
                    ),
                  ),
                ]),
    );
  }
}
