import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/data/models/walkin_model.dart';
import 'package:tabletapp/presentation/screens/global.dart';
import 'package:tabletapp/presentation/screens/home/home.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/variations_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/material_textform_field.dart';
import '../cart/cart.dart';

class qty_screen extends StatefulWidget {
  qty_screen({super.key});

  @override
  State<qty_screen> createState() => _orderFlowState();
//  State<qty_screen> createState() => _MyHomePageState();
}

class _orderFlowState extends State<qty_screen> {
  String txtNote = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = GlobalDala.cartData[Constant.note].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(GlobalDala.cartData[Constant.productName],
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppColors.appColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(30),
                child: Column(children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120.0, // Set an initial height
                    child: TextFormField(
                      controller: _controller,
                      style: const TextStyle(color: AppColors.appColor),
                      expands: true,
                      maxLines: null,
                      // Set to null for unlimited lines
                      decoration: InputDecoration(
                        labelText: 'Note',
                        labelStyle: TextStyle(color: AppColors.appColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.appColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.appColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  QuantitySelector(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            SystemNavigator.pop();
                          }
                        },
                        child: Text('CANCEL',
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.appColor),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your button 2 logic here

                          if (_controller.text.isNotEmpty) {
                            GlobalDala.cartData[Constant.fullDescription] =
                                "${GlobalDala.cartData[Constant.fullDescription]}\n**${_controller.text}";

                            GlobalDala.cartData[Constant.note] =
                                _controller.text;
                          }


                          GlobalDala.cartData[Constant.quantity] = quantity;
                          GlobalDala.cartData[Constant.price] =
                              (GlobalDala.cartData[Constant.variationsPrice] ??
                                      0.0) +
                                  (GlobalDala.cartData[Constant.actualPrice] ??
                                      0.0);
                          GlobalDala.cartData[Constant.totalUnitPrice] =
                              (GlobalDala.cartData[Constant.variationsPrice] ??
                                      0.0) +
                                  (GlobalDala.cartData[Constant.actualPrice] ??
                                      0.0);

                          GlobalDala.cartData[Constant.subTotal] =
                              ((GlobalDala.cartData[Constant.price] ?? 0.0) *
                                  quantity.toDouble());

                          /*      GlobalDala.cartData[Constant.totalPrice] = ((GlobalDala.cartData[Constant.variationsPrice] ??
                                      0.0) *
                                  quantity.toDouble());

*/

                          GlobalDala.cartData[Constant.taxPerUnit1] = 0.0;
                          GlobalDala.cartData[Constant.taxPerUnit2] = 0.0;
                          GlobalDala.cartData[Constant.taxPerUnit3] = 0.0;
                          if (GlobalDala.cartData[Constant.taxId1] == 1) {
                            GlobalDala.cartData[Constant.taxPerUnit1] =
                                ((GlobalDala.cartData[Constant.subTotal] ??
                                        0.0) *
                                    (GlobalDala.cartData[Constant.taxRate1] ??
                                        0.0) /
                                    100);
                          }
                          if (GlobalDala.cartData[Constant.taxId2] == 2) {
                            GlobalDala.cartData[Constant.taxPerUnit2] =
                                ((GlobalDala.cartData[Constant.subTotal] ??
                                        0.0) *
                                    (GlobalDala.cartData[Constant.taxRate2] ??
                                        0.0) /
                                    100);
                          }
                          if (GlobalDala.cartData[Constant.taxId3] == 3) {
                            GlobalDala.cartData[Constant.taxPerUnit3] =
                                ((GlobalDala.cartData[Constant.subTotal] ??
                                        0.0) *
                                    (GlobalDala.cartData[Constant.taxRate3] ??
                                        0.0) /
                                    100);
                          }

                          GlobalDala.cartData[Constant.totalTax1] =
                              GlobalDala.cartData[Constant.taxPerUnit1];
                          GlobalDala.cartData[Constant.totalTax2] =
                              GlobalDala.cartData[Constant.taxPerUnit2];
                          GlobalDala.cartData[Constant.totalTax3] =
                              GlobalDala.cartData[Constant.taxPerUnit3];

                          double itemTotal =
                              (GlobalDala.cartData[Constant.subTotal] ?? 0.0) +
                                  (GlobalDala.cartData[Constant.taxPerUnit1] ??
                                      0.0) +
                                  (GlobalDala.cartData[Constant.taxPerUnit2] ??
                                      0.0) +
                                  (GlobalDala.cartData[Constant.taxPerUnit3] ??
                                      0.0);

                          GlobalDala.cartData[Constant.itemTotal] = itemTotal;
// Convert the result to a string with two decimal places

                          saveDataToLocal(context);
                        },
                        child: const Text('Add to cart',
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.appColor),
                        ),
                      ),
                    ],
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}

Future<void> saveDataToLocal(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (GlobalDala.isEdite) {
    GlobalDala.isEdite = false;

    log('GlobalDala.cartDataList Edit size00  : ${GlobalDala.cartDataList.length}');

    GlobalDala.cartDataList[GlobalDala.editIndex] = GlobalDala.cartData;
    List<String> updatedCartDataList = GlobalDala.cartDataList
        .map<String>((item) => json.encode(item))
        .toList();
    prefs.setStringList('cartDataList', updatedCartDataList);

    log('GlobalDala.cartDataList Edit size  : ${updatedCartDataList.length}');

    Navigator.of(context).pop();
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => cart())
    );

    //log('GlobalDala.cartDataList Edit : ${GlobalDala.cartDataList}');
  } else {
    List<String>? cartDataList = prefs.getStringList('cartDataList');

    // Add the current record to the lists
    cartDataList ??= [];

    GlobalDala.cartData[Constant.lineNo] = cartDataList.length + 1;

    cartDataList.add(json.encode(GlobalDala.cartData));
    prefs.setStringList('cartDataList', cartDataList);
    GlobalDala.itemCount = cartDataList.length;

    if (Navigator.canPop(context)) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushNamed(context, "/home");
    } else {
      SystemNavigator.pop();
    }

    log('GlobalDala.cartDataList Add : ${GlobalDala.cartDataList}');
  }
}

int quantity = 1;

class QuantitySelector extends StatefulWidget {
  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  // Initial quantity

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity = 1;
  }

  @override
  void dispose() {
    // This method is called when the screen is dismissed
    // You can perform cleanup or other actions here
    super.dispose();
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
            child: Text(
          'Quantity : ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.appColor,
          ),
        )),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red, // Set the background color
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
            color: Colors.white, // Set the icon color
            icon: Icon(Icons.remove),
            onPressed: () {
              decrementQuantity();
            },
          ),
        ),
        Container(
          width: 40,
          height: 40,
          child: Center(
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red, // Set the background color
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
            color: Colors.white, // Set the icon color
            icon: Icon(Icons.add),
            onPressed: () {
              incrementQuantity();
            },
          ),
        ),
      ],
    );
  }
}
