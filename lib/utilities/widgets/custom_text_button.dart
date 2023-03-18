import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.underline});
  final VoidCallback onPressed;
  final String text;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'worksans',
            fontSize: 20,
            color: GlobalVariables.btnBackgroundColor,
            fontWeight: FontWeight.bold,
            decoration:
                underline ? TextDecoration.underline : TextDecoration.none,
            decorationThickness: 3,
          ),
        ),
      ),
    );
  }
}
