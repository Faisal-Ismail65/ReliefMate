import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class DonationDetailTile extends StatelessWidget {
  final String name;
  final String value;
  const DonationDetailTile(
      {super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                  fontSize: 30, color: GlobalVariables.btnBackgroundColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 2,
              color: GlobalVariables.btnBackgroundColor,
            )
          ],
        ),
      ),
    );
  }
}
