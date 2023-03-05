import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  const ProfileTile(
      {super.key, required this.fieldName, required this.fieldValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 5),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.redAccent,
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
