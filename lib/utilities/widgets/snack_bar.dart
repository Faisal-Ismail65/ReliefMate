import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: Colors.redAccent,
      elevation: 3,
      duration: const Duration(seconds: 3),
    ),
  );
}
