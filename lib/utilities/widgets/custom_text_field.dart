// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.obseureText,
      this.inputType,
      this.icon});
  final TextInputType? inputType;
  final TextEditingController controller;
  final String labelText;
  Icon? icon;
  bool obseureText = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      enableSuggestions: false,
      autocorrect: false,
      obscureText: obseureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: GlobalVariables.btnBackgroundColor),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: GlobalVariables.btnBackgroundColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
