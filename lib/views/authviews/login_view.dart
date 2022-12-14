// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliefmate/constants/routes.dart';
import 'package:reliefmate/services/auth/auth_exceptions.dart';
import 'package:reliefmate/services/auth/auth_service.dart';
import 'package:reliefmate/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool showPassword = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('ReliefMate',
                textStyle: GoogleFonts.laBelleAurore(
                  fontSize: 30,
                )),
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
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 0,
          ),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 30,
                    fontFamily: 'worksans',
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
                      suffixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextField(
                        obscureText: !showPassword,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Enter Password',
                          suffixIcon: const Icon(Icons.password),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      try {
                        await AuthService.firebase().logIn(
                          email: email,
                          password: password,
                        );
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          bottomBarView,
                          (route) => false,
                        );
                      } on UserNotFoundAuthException {
                        await showErrorDialog(
                          context,
                          'User Not Found!',
                        );
                      } on WrongPasswordAuthException {
                        await showErrorDialog(
                          context,
                          'Wrong Credentials!',
                        );
                      } on GenericAuthException {
                        await showErrorDialog(
                          context,
                          'Login Failed!',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'worksans',
                          letterSpacing: 2,
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            signupView, (route) => false);
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontFamily: 'worksans',
                          fontSize: 20,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationThickness: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
