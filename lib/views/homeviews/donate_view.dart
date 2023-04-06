// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/donation/donation_firestore_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/custom_elevated_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';

class DonateView extends StatefulWidget {
  const DonateView({super.key});

  @override
  State<DonateView> createState() => _DonateViewState();
}

class _DonateViewState extends State<DonateView> {
  final TextEditingController _descriptionController1 = TextEditingController();
  final TextEditingController _descriptionController2 = TextEditingController();
  final TextEditingController _descriptionController3 = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _userId = FirebaseAuth.instance.currentUser!.uid;

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

  int index = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void createDonation() async {
    bool isForm = _addressController.text.isNotEmpty &&
        _descriptionController1.text.isNotEmpty;
    if (isForm) {
      if (_donationKey.currentState!.validate()) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
        String res = await DonationFirestoreMethods().createDonationa(
          donorid: userData['uid'],
          donorEmail: userData['email'],
          donorName: userData['name'],
          donorCnic: userData['cnic'],
          donorPhoneNumber: userData['phoneNumber'],
          donationAddress: userData['address'],
          donationDesc: _descriptionController1.text,
          donationMsg: _messageController.text,
          donationExpDate:
              '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
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
          showSnackBar(context, 'Donated Succesfully');
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
      appBar: const SimpleAppBar(text: "Donations"),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              iconSize: 20,
                              hint: const Text(
                                'Donation Category',
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
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: index > 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
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
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: index > 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
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
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            GlobalVariables.btnBackgroundColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: GlobalVariables.btnBackgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: GlobalVariables.btnBackgroundColor,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Expiration Date:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(
                                      Icons.edit_calendar,
                                      size: 30,
                                      color: GlobalVariables.btnBackgroundColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CustomElevatedButton(
                              onPressed: createDonation, text: "Donate")
                        ],
                      ),
                    ),
                  ),
                ]),
    );
  }
}
