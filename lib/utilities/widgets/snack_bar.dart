import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: GlobalVariables.btnBackgroundColor,
      elevation: 3,
      duration: const Duration(seconds: 3),
    ),
  );
}
