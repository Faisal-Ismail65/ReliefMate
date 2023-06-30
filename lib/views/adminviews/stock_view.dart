import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/models/category.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/views/adminviews/stock_detail_view.dart';

class StockView extends StatefulWidget {
  const StockView({super.key});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  List<Category> categoryList = [];
  List<String?> edibles = [];
  List<String?> residence = [];
  List<String?> wearables = [];
  List<String?> other = [];
  List<String?> medicine = [];
  bool isLoading = false;

  Future<void> getStock() async {
    setState(() {
      isLoading = true;
    });
    var query = await FirebaseFirestore.instance.collection('donations').get();
    for (var donationDoc in query.docs) {
      QuerySnapshot donation = await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationDoc['id'])
          .collection('category')
          .get();
      for (var categoryDoc in donation.docs) {
        categoryList.add(Category.fromSnap(categoryDoc));
      }
      medicine = categoryList
          .map((e) => e.medicine)
          .where((element) => element != null)
          .toList();
      edibles = categoryList
          .map((e) => e.edibles)
          .where((element) => element != null)
          .toList();
      wearables = categoryList
          .map((e) => e.wearables)
          .where((element) => element != null)
          .toList();
      residence = categoryList
          .map((e) => e.residence)
          .where((element) => element != null)
          .toList();
      other = categoryList
          .map((e) => e.other)
          .where((element) => element != null)
          .toList();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getStock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: 'Stock'),
      body: isLoading
          ? const Loader()
          : GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StockDetailView(
                          stockItems: edibles, title: 'Edibles'),
                    ));
                  },
                  child: Card(
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: GlobalVariables.btnBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            edibles.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Edibles',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StockDetailView(
                          stockItems: medicine, title: 'Medicines'),
                    ));
                  },
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
                          Text(
                            medicine.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Medicine',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StockDetailView(
                          stockItems: wearables, title: 'Wearables'),
                    ));
                  },
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
                          Text(
                            wearables.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Wearables',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StockDetailView(
                          stockItems: residence, title: 'Residence'),
                    ));
                  },
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
                          Text(
                            residence.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Residence',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StockDetailView(
                        stockItems: other,
                        title: 'Others',
                      ),
                    ));
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: GlobalVariables.btnBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            other.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Other',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
