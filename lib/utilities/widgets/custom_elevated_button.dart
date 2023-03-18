import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: GlobalVariables.btnBackgroundColor,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'worksans',
            letterSpacing: 2,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
