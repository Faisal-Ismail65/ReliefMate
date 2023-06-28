// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/notification/send_notification_service.dart';
import 'package:reliefmate/services/request/request_firestore_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/utils/utils.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/custom_elevated_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class RequestView extends StatefulWidget {
  final user;
  const RequestView({super.key, required this.user});

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
      final location = await getUserLocation();

      final address = await getUserAddress(
          latitude: location.latitude, longitude: location.longitude);
      _addressController.text = '${address.street} ${address.locality}';

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
          requesterId: widget.user['uid'],
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
          SendNotificationService().sendNoticationToAdmin(
              title: 'Donation Request',
              body:
                  '${widget.user['name']} created a donation request with category $category1 $category2 $category3');
        }
      }
    } else {
      showSnackBar(context, "Please fill all Required fields!");
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                                      color: GlobalVariables.btnBackgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: index > 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                                      color: GlobalVariables.btnBackgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: index > 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                          Visibility(
                            visible: index > 2,
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
                                      color: GlobalVariables.btnBackgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            minLines: 3,
                            maxLines: 3,
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Optional Message',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: GlobalVariables.btnBackgroundColor),
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
                          const SizedBox(
                            height: 10,
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
