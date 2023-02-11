// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliefmate/services/auth/auth_exceptions.dart';
import 'package:reliefmate/services/auth/auth_methods.dart';
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
    setState(() {
      isLoading = true;
    });
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      if (email == 'admin' && password == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminView(),
          ),
        );
      } else {
        try {
          String res = await AuthMethods().loginUser(
            email: email,
            password: password,
          );
          if (res == 'Success') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const BottomBarView(),
              ),
            );
            showSnackBar(context, 'Logged In Succesffully');
          }
        } on UserNotFoundAuthException {
          showSnackBar(context, 'User Not Found!');
        } on WrongPasswordAuthException {
          showSnackBar(context, 'Wrong Credentials!');
        } on GenericAuthException {
          showSnackBar(context, 'Login Failed!');
        }
      }
    } else {
      showSnackBar(context, 'Enter All Credentials!');
    }
    setState(() {
      isLoading = false;
    });
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
        backgroundColor: Colors.redAccent,
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
                    controller: _emailController,
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
                        controller: _passwordController,
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
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: Center(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
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
                      onPressed: navigateToCreateAccount,
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
