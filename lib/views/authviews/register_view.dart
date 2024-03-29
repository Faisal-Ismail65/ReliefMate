// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliefmate/services/auth/auth_exceptions.dart';
import 'package:reliefmate/services/auth/auth_methods.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/custom_elevated_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_button.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/authviews/login_view.dart';
import 'package:reliefmate/views/homeviews/create_profile.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  void registerUser() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await AuthMethods().signUpUser(email: email, password: password);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const CreateProfile(),
        ));
      } else {
        showSnackBar(context, 'Enter All Credentials!');
      }
    } on WeakPasswordAuthException {
      showSnackBar(context, 'Weak Password');
    } on EmailAlreadyInUseAuthException {
      showSnackBar(
        context,
        'Email Already In Use!',
      );
    } on InvalidEmailAuthException {
      showSnackBar(
        context,
        'Invalid Email Entered!',
      );
    } on GenericAuthException {
      showSnackBar(
        context,
        'Failed To Register!',
      );
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginView(),
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
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
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
                      'Join and Register!',
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
                inputType: TextInputType.emailAddress,
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
                  : CustomElevatedButton(
                      onPressed: registerUser, text: 'Register'),
              CustomTextButton(
                onPressed: navigateToLogin,
                text: 'Already Have Account',
                underline: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
