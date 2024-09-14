import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tabletapp/core/theme/app_colors.dart';
import 'package:tabletapp/data/models/walkin_model.dart';
import 'package:tabletapp/presentation/screens/global.dart';
import 'package:tabletapp/presentation/screens/orderflow/qty_screen.dart';

import '../../../data/models/variations_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';

class VariationsScreen extends StatefulWidget {
  List<VariationsModel> variationsList;



  VariationsScreen(this.variationsList, {super.key});

  @override
  _VariationsScreenState createState() => _VariationsScreenState();
}

class _VariationsScreenState extends State<VariationsScreen> {
  int currentVariationIndex = 0;
  double allPrice = 0.0;
  Map<int, List<bool>> selectedItemsMap = {};
  Map<int, List<Datum>> selectedItemsDataMap = {};
  Map<int, List<Datum>> selectedItemsLevel = {};
  int maxSel = 0;

  @override
  void initState() {
    super.initState();
    initializeSelectedItems();
  }
  void initializeSelectedItems() {
    // Fetch the selected items list from GlobalData
    List<dynamic> selectedItems = GlobalDala.cartData[Constant.selectedItemsLevel] ?? [];

    // Debugging: print the selected items
    print('Preselected items: $selectedItems');

    // Initialize the map for each variation index
    for (int i = 0; i < widget.variationsList.length; i++) {
      final currentVariationsModel = widget.variationsList[i];
      final currentDataList = currentVariationsModel.data ?? [];

      if (!selectedItemsMap.containsKey(i) || selectedItemsMap[i]!.length != currentDataList.length) {
        selectedItemsMap[i] = List.generate(currentDataList.length, (index) => false);

        // Set preselected items to true based on their ID
        for (int j = 0; j < currentDataList.length; j++) {
          if (selectedItems.any((item) => item['id'] == currentDataList[j].id)) {
            selectedItemsMap[i]![j] = true;
          }
        }
      }
    }
    selLength = selectedItemsMap[currentVariationIndex]
        ?.where((item) => item)
        .length ??
        0;
    // Debugging: print the selectedItemsMap
  }
  var selLength =
  0;

  @override
  Widget build(BuildContext context) {
    
    final currentVariationsModel = widget.variationsList.isNotEmpty
        ? widget.variationsList[currentVariationIndex]
        : null;
    final currentDataList = currentVariationsModel?.data ?? [];

    if (!selectedItemsMap.containsKey(currentVariationIndex) ||
        selectedItemsMap[currentVariationIndex]!.length !=
            currentDataList.length) {
      selectedItemsMap[currentVariationIndex] =
          List.generate(currentDataList.length, (index) => false);


    }
    maxSel=currentVariationsModel?.qtyLevel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Variations ${currentVariationsModel?.nameLevel}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentDataList.length,
              itemBuilder: (context, index) {
                final Datum datum = currentDataList[index];



                return CheckboxListTile(
                  title: Text(datum.name ?? ''),
                  subtitle: Text('Price: ${datum.price ?? 0.0}'),
                  value: selectedItemsMap[currentVariationIndex]![index],
                  onChanged: (value) async {
                    // Handle checkbox selection

                    if (value != null) {

                      if (value && selLength == maxSel)
                      {
                        showSnackBarInDialog(context, "You can select only ${maxSel} item , uncheck other! ");
                      }
                      else
                        {
                          setState(() {
                            selectedItemsMap[currentVariationIndex]![index] = value;
                          });
                          selLength = selectedItemsMap[currentVariationIndex]?.where((item) => item).length ?? 0;

                          if (selLength == maxSel ) {
                            setState(() {
                              selectedItemsLevel[currentVariationIndex] = currentDataList
                                  .asMap()
                                  .entries
                                  .where((entry) => selectedItemsMap[currentVariationIndex]![entry.key])
                                  .map((entry) => entry.value)
                                  .toList();
                            });

                            await Future.delayed(Duration(milliseconds: 300));

                            if (currentVariationIndex < widget.variationsList.length - 1) {
                              setState(() {
                                currentVariationIndex = (currentVariationIndex + 1) % widget.variationsList.length;
                                selLength = selectedItemsMap[currentVariationIndex]
                                    ?.where((item) => item)
                                    .length ??
                                    0;
                              });
                            } else {
                              double allPrice = 0.0;
                              GlobalDala.cartData[Constant.fullDescription] =  GlobalDala.cartData[Constant.productName];
                              for (int i = 0; i < widget.variationsList.length; i++)
                              {List<Datum>? selectedItems = selectedItemsLevel[i];

                                if (selectedItems != null && selectedItems.isNotEmpty) {
                                  for (Datum selectedDatum in selectedItems) {
                                    GlobalDala.cartData[Constant.fullDescription] =
                                    "${GlobalDala.cartData[Constant.fullDescription]}\n*${selectedDatum.name}";
                                    allPrice += selectedDatum.price ?? 0.0;
                                  }
                                }
                              }
                              GlobalDala.cartData[Constant.variationsPrice] = allPrice;

                              Map<String, dynamic> serializedSelectedItemsLevel = {};
                              selectedItemsLevel.forEach((key, value) {
                                serializedSelectedItemsLevel[key.toString()] = value.map((datum) => datum.toJson()).toList();
                              });

                              List<dynamic> serializedSelectedItemsList = [];
                              serializedSelectedItemsLevel.values.forEach((value) {
                                serializedSelectedItemsList.addAll(value);
                              });
                              GlobalDala.cartData[Constant.selectedItemsLevel] = serializedSelectedItemsList;


                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(builder: (context) => qty_screen()),
                              );
                            }
                          }

                        }




                    }
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    // Move to the previous set of variations

                    setState(() {
                      if (currentVariationIndex == 0) {
                        /*  ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('This is the first position.'),
                        ),
                      );*/
                      } else {
                        currentVariationIndex = (currentVariationIndex - 1) %
                            widget.variationsList.length;
                        selLength = selectedItemsMap[currentVariationIndex]
                            ?.where((item) => item)
                            .length ??
                            0;
                      }
                    });
                  },
                  child:
                      Text('Previous', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.appColor),
                  )),
              Center(
                  child: Text(
                '${currentVariationIndex + 1} / ${widget.variationsList.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appColor,
                ),
              )),
              ElevatedButton(
                  onPressed: () {

                    setState(() {
                      /* selLength = selectedItemsMap[currentVariationIndex]
                              ?.where((item) => item)
                              .length ??
                          0;*/

                      if (selLength >= currentVariationsModel?.mandatoryLevel) {

                        if (selLength <= maxSel) {
                          selectedItemsLevel[currentVariationIndex] =
                              currentDataList
                                  .asMap()
                                  .entries
                                  .where((entry) => selectedItemsMap[
                              currentVariationIndex]![entry.key])
                                  .map((entry) => entry.value)
                                  .toList();

                          print(
                              "LevelSize ${selectedItemsLevel.length}");

                          // Move to the next level
                          if (currentVariationIndex < widget.variationsList.length - 1)
                          {currentVariationIndex = (currentVariationIndex + 1) %
                                widget.variationsList.length;
                          selLength = selectedItemsMap[currentVariationIndex]
                              ?.where((item) => item)
                              .length ??
                              0;
                          }
                          else {
                            allPrice = 0.0;
                            GlobalDala.cartData[Constant.fullDescription] =  GlobalDala.cartData[Constant.productName];

                            for (int i = 0;
                            i < widget.variationsList.length;
                            i++) {
                              List<Datum>? selectedItems =
                              selectedItemsLevel[i];
                              if (selectedItems != null &&
                                  selectedItems.isNotEmpty) {
                                for (Datum selectedDatum in selectedItems) {

                                GlobalDala.cartData[Constant.fullDescription]="${GlobalDala.cartData[Constant.fullDescription]}\n*${selectedDatum.name}";

                                  allPrice = allPrice + (selectedDatum.price ?? 0.0);
                                }
                              }
                            }
                            GlobalDala.cartData[Constant.variationsPrice] = allPrice;
                            Map<String, dynamic> serializedSelectedItemsLevel = {};

                            selectedItemsLevel.forEach((key, value) {
                              serializedSelectedItemsLevel[key.toString()] =
                                  value.map((datum) => datum.toJson()).toList();
                            });

                            List<dynamic> serializedSelectedItemsList = [];

                            serializedSelectedItemsLevel.values.forEach((value) {
                              serializedSelectedItemsList.addAll(value);
                            });

                            print('serializedSelectedItemsLevel $serializedSelectedItemsList');
/* Map<String, dynamic> serializedSelectedItemsLevel = {};

                            selectedItemsLevel.forEach((key, value) {
                              serializedSelectedItemsLevel[key.toString()] =
                                  value.map((datum) => datum.toJson()).toList();
                            });
print('serializedSelectedItemsLevel $serializedSelectedItemsLevel');*/
                            GlobalDala.cartData[Constant.selectedItemsLevel] = serializedSelectedItemsList;



                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        qty_screen()));
                          }
                        }
                        else
                          {
                            showSnackBarInDialog(context, "Please select only ${maxSel} item");


                          }

                      } else {
                        showSnackBarInDialog(context, "Please select at least 1 item");


                      }
                    });
                  },
                  child: Text('Next', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.appColor),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
