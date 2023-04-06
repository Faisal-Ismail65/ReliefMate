import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class GridItem extends StatelessWidget {
  const GridItem(
      {super.key,
      required this.path,
      required this.text,
      required this.height,
      required this.width});
  final String path;
  final String text;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 70,
        child: Container(
          decoration: BoxDecoration(
            color: GlobalVariables.btnBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                path,
                width: width,
                height: height,
                color: Colors.white,
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
