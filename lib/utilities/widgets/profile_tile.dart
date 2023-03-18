import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class ProfileTile extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  const ProfileTile(
      {super.key, required this.fieldName, required this.fieldValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.only(top: 25, bottom: 5),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: GlobalVariables.appBarColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              fieldName,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              fieldValue,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
