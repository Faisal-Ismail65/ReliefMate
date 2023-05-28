import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';

class StockDetailView extends StatelessWidget {
  final String title;
  final List<String?> stockItems;
  const StockDetailView(
      {super.key, required this.stockItems, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(text: title),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        itemCount: stockItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              tileColor: GlobalVariables.appBarBackgroundColor,
              title: Text(
                stockItems[index]!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
