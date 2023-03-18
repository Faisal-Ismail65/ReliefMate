import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/custom_elevated_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';

class DonateView extends StatefulWidget {
  const DonateView({super.key});

  @override
  State<DonateView> createState() => _DonateViewState();
}

class _DonateViewState extends State<DonateView> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  var userData = {};
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    getData();
    super.initState();
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
      _addressController.text = userData['address'];
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: const SimpleAppBar(text: "Donations"),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _addressController,
                    labelText: 'Enter Address',
                    obseureText: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 3,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter Some  Description',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: GlobalVariables.btnBackgroundColor),
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
                              color: GlobalVariables.btnBackgroundColor),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: GlobalVariables.btnBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Expiration Date:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                  CustomElevatedButton(onPressed: () {}, text: "Donate")
                ],
              ),
            ),
          );
  }
}
