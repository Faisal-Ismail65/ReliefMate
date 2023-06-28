import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class ProfileTile extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  const ProfileTile(
      {super.key, required this.fieldName, required this.fieldValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600),
          ),
          Text(
            fieldValue,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
