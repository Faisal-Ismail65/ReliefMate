import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class DrawerMenuTile extends StatelessWidget {
  const DrawerMenuTile(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});
  final String text;
  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: icon,
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: GlobalVariables.btnBackgroundColor,
            fontFamily: 'worksans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
