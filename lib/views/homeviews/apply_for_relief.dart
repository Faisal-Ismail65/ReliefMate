// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/profile/firestore_methods.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';

class ApplyForRelief extends StatefulWidget {
  const ApplyForRelief({super.key});

  @override
  State<ApplyForRelief> createState() => _ApplyForReliefState();
}

class _ApplyForReliefState extends State<ApplyForRelief> {
  late final TextEditingController _name;
  late final TextEditingController _cnic;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _address;
  final _userEmail = FirebaseAuth.instance.currentUser!.email;
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  final _profileKey = GlobalKey<FormState>();
  String category = 'Medicine';
  List<String> needs = [
    'Edibles',
    'Wearables',
    'Residence',
    'Medicine',
  ];
  void createProfile() async {
    bool isForm = _name.text.isNotEmpty &&
        _cnic.text.isNotEmpty &&
        _phoneNumber.text.isNotEmpty &&
        _address.text.isNotEmpty;

    if (isForm) {
      if (_profileKey.currentState!.validate()) {
        String res = await FirestoreMethods().createProfile(
          uid: _userId,
          email: _userEmail!,
          name: _name.text,
          cnic: _cnic.text,
          phoneNumber: _phoneNumber.text,
          address: _address.text,
          need: category,
        );

        if (res == 'Success') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomBarView(),
          ));
          showSnackBar(context, 'Your Profile Is Created Succesfully');
        }
      }
    } else {
      showSnackBar(context, "Please fill all fields!");
    }
  }

  @override
  void initState() {
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
            fontSize: 20,
            fontFamily: 'worksans',
            letterSpacing: 2,
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _profileKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  hint: const Text(
                    'Need',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
