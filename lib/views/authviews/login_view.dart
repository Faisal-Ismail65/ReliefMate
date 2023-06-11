// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliefmate/models/auth_user.dart';
import 'package:reliefmate/services/auth/auth_exceptions.dart';
import 'package:reliefmate/services/auth/auth_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/custom_elevated_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/adminviews/admin_view.dart';
import 'package:reliefmate/views/authviews/register_view.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool showPassword = false;
  bool isLoading = false;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  void loginUser() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        String res = await AuthMethods().loginUser(
          email: email,
          password: password,
        );
        if (res == 'Success') {
          final AuthUser user = await AuthMethods().getUserDetails();
          if (user.type == 'admin') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AdminView(),
              ),
            );
          } else if (user.type == 'user') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const BottomBarView(),
              ),
            );
          }
          showSnackBar(context, 'Logged In Succesffully');
        }
      } on UserNotFoundAuthException {
        showSnackBar(context, 'User Not Found!');
      } on WrongPasswordAuthException {
        showSnackBar(context, 'Wrong Credentials!');
      } on GenericAuthException {
        showSnackBar(context, 'Login Failed!');
      }
    } else {
      showSnackBar(context, 'Enter All Credentials!');
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToCreateAccount() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RegisterView(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'ReliefMate',
              textStyle: GoogleFonts.pacifico(
                fontSize: 30,
              ),
            ),
          ],
          totalRepeatCount: 3,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      fontSize: 28,
                      color: GlobalVariables.appBarColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sign in to continue!',
                    style: TextStyle(
                      fontSize: 18,
                      color: GlobalVariables.appBarColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
              controller: _emailController,
              labelText: 'Enter Email',
              icon: const Icon(
                Icons.email,
              ),
              obseureText: false,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Enter Password',
              icon: const Icon(Icons.password),
              obseureText: !showPassword,
            ),
            Row(
              children: [
                Checkbox(
                  value: showPassword,
                  onChanged: (value) {
                    setState(() {
                      if (showPassword) {
                        showPassword = false;
                      } else {
                        showPassword = true;
                      }
                    });
                  },
                ),
                const Text(
                  'Show Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            isLoading
                ? const Loader()
                : CustomElevatedButton(onPressed: loginUser, text: 'Login'),
            CustomTextButton(
                onPressed: navigateToCreateAccount,
                text: 'Create Account',
                underline: true),
          ],
        ),
      ),
    );
  }
}
