import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/custom_elevated_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(text: 'Forget Password'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            CustomTextField(
                controller: _emailController,
                labelText: 'Enter Email',
                obseureText: false),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(
                          email: _emailController.text.trim())
                      .then((value) {
                    Navigator.of(context).pop();
                    showSnackBar(
                        context, 'Reset Password Email is Sent Successfully');
                  }).onError((error, stackTrace) {
                    showSnackBar(context, 'Something Went Wrong!');
                  });
                },
                text: 'Reset password')
          ],
        ),
      ),
    );
  }
}
