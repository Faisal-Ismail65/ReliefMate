// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
          fontFamily: 'worksans',
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
