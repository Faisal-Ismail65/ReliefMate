import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.path, required this.label});
  final String path;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  path,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.appBarColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
