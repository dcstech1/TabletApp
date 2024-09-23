import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../data/models/recall_model.dart';
import '../../../data/models/submit_order.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../cart/cart.dart';
import '../cart/paymentscreen.dart';
import '../global.dart';
import '../home/home.dart';

class BarTabScreen extends StatefulWidget {
  @override
  State<BarTabScreen> createState() => _BarTabState();
}

class _BarTabState extends State<BarTabScreen> {
  // Controller to handle the input in the TextField
  final TextEditingController _nameController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bar Tab"),
        centerTitle: true,
        backgroundColor: AppColors.appColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: nextClick,
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.appColor),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<RecallModel>>(
                future: HomeRepository().getOrderlistForBarTab(
                    GlobalDala.cartPayNowDataList[Constant.userIdMain]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No active orders found.'));
                  } else {
                    final recallList = snapshot.data!;

                    return ListView.builder(
                      itemCount: recallList.length,
                      itemBuilder: (context, index) {
                        final order = recallList[index];
                        final orderId = order.id ?? 00;
                        final tableName = order.tableName ?? 'N/A';
                        final serverName = order.serverName ?? 'N/A';
                        final orderTotal = order.orderTotal ?? 0.0;

                        String dateTimeString =
                            '${order.onDate} ${order.onTime}';

                        DateFormat format = DateFormat('dd/MM/yyyy HH:mm:ss');
                        DateTime orderDateTime = format.parse(dateTimeString);

                        Duration difference =
                            DateTime.now().difference(orderDateTime);

                        String differenceString;
                        if (difference.inDays > 0) {
                          differenceString = '${difference.inDays} days ago';
                        } else if (difference.inHours > 0) {
                          differenceString = '${difference.inHours} hours ago';
                        } else {
                          differenceString =
                              '${difference.inMinutes} minutes ago';
                        }

                        return InkWell(
                          onTap: () {
                            // Handle container click
                            print('Container clicked for order $orderId');
                            _handleEdit(order);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 5.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // Background color
                              borderRadius: BorderRadius.circular(8.0),
                              // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  // Shadow color
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // Shadow position
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '[$tableName] \$${orderTotal.toStringAsFixed(2)}'),
                                      SizedBox(height: 4.0),
                                      Text('$serverName'),
                                      SizedBox(height: 4.0),
                                      Text('$differenceString Ord#:$orderId'),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: _nameController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Enter BarTab Name",
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                           /*       const SizedBox(height: 10),
                                                  if (isLoading)
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        valueColor:
                                                        AlwaysStoppedAnimation<Color>(AppColors.appColor),
                                                      ),
                                                    ),*/
                                                ],
                                              ),

                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    if (_nameController.text ==
                                                        "") {
                                                      showSnackBarInDialog(
                                                          context,
                                                          "Enter Bar Tab Name.!");
                                                      return;
                                                    } else {


                                                      try {
                                                        SubmitOrderModel? submitOrderModel;
                                                        final Map<String, dynamic> requestData = {
                                                          "orderid":order.id,
                                                          "barTabName":_nameController.text,
                                                          "barTabInfo":"Bar Tab :${_nameController.text}"
                                                        };
                                                        final response = await HomeRepository().postBarTabEdit(body: requestData);

                                                        if (response is Map<String, dynamic> && response.containsKey('error')) {

                                                          String errorMessage = response['error'];

                                                          showSnackBarInDialogClose(context, "Error while edit bartab: $errorMessage", () {
                                                            Navigator.of(context).pop();
                                                          });
                                                        } else if (response is SubmitOrderModel) {
                                                          submitOrderModel = response;
                                                          showSnackBarInDialogClose(context, "BarTab name edit successfully", () {
                                                            setState(() {

                                                            });
                                                            Navigator.of(context).pop();
                                                          });
                                                        }


                                                      } catch (e) {
                                                        showSnackBarInDialogClose(context, "An error occurred. Please try again later", () {
                                                          Navigator.of(context).pop();
                                                        });
                                                      } finally {

                                                      }



                                                    }
                                                  },
                                                  child: Text('Update'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Cancel
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.payment),
                                      onPressed: () {
                                        if (order.orderTotal! > 0) {

                                          GlobalDala.cartPayNowDataList[Constant.idMain] = order.id;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentScreen(
                                                          order.orderTotal ??
                                                              0.00)));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextClick() {
    if (_nameController.text == "") {
      showSnackBarInDialog(context, "Enter Bar Tab Name.!");
      return;
    } else {
      GlobalDala.cartPayNowDataList[Constant.tableNameMain] =
          _nameController.text;
      GlobalDala.cartPayNowDataList[Constant.clientNameMain] =
          _nameController.text;
      GlobalDala.cartPayNowDataList[Constant.tableInfoMain] =
          "Bar Tab :${_nameController.text}";
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => home("BarTab")));
    }
  }

  void _handleEdit(RecallModel recall) {
    setOrderData(recall);
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) => home("BarTab")));
  }

  Future<void> setOrderData(RecallModel recall) async {
    List<String>? cartDataList = [];

    GlobalDala.cartPayNowDataList[Constant.idMain] = recall.id;
    GlobalDala.cartPayNowDataList[Constant.driverId] = recall.driverId;
    GlobalDala.cartPayNowDataList[Constant.paymentTypeMain] = "onCounter";
    GlobalDala.cartPayNowDataList[Constant.orderTypeMain] = recall.orderType;
    GlobalDala.cartPayNowDataList[Constant.tableIdMain] = recall.tableId;
    GlobalDala.cartPayNowDataList[Constant.tableNameMain] = recall.tableName;
    GlobalDala.cartPayNowDataList[Constant.tableInfoMain] = recall.tableInfo;
    GlobalDala.cartPayNowDataList[Constant.guestNoMain] = recall.guestNo;
    GlobalDala.cartPayNowDataList[Constant.userIdMain] = recall.userId;
    GlobalDala.cartPayNowDataList[Constant.onDateMain] = recall.onDate;
    GlobalDala.cartPayNowDataList[Constant.onTimeMain] = recall.onTime;
    GlobalDala.cartPayNowDataList[Constant.taxId1Main] = recall.taxId1;
    GlobalDala.cartPayNowDataList[Constant.taxId2Main] = recall.taxId2;
    GlobalDala.cartPayNowDataList[Constant.taxId3Main] = recall.taxId3;
    GlobalDala.cartPayNowDataList[Constant.taxId4Main] = recall.taxId4;
    GlobalDala.cartPayNowDataList[Constant.taxId5Main] = recall.taxId5;
    GlobalDala.cartPayNowDataList[Constant.taxId6Main] = recall.taxId6;
    GlobalDala.cartPayNowDataList[Constant.totalTax1Main] = recall.totalTax1;
    GlobalDala.cartPayNowDataList[Constant.totalTax2Main] = recall.totalTax2;
    GlobalDala.cartPayNowDataList[Constant.totalTax3Main] = recall.totalTax3;
    GlobalDala.cartPayNowDataList[Constant.totalTax4Main] = recall.totalTax4;
    GlobalDala.cartPayNowDataList[Constant.totalTax5Main] = recall.totalTax5;
    GlobalDala.cartPayNowDataList[Constant.totalTax6Main] = recall.totalTax6;
    GlobalDala.cartPayNowDataList[Constant.stationIdMain] = recall.stationId;
    GlobalDala.cartPayNowDataList[Constant.locIdMain] = recall.locId;
    GlobalDala.cartPayNowDataList[Constant.shiftIdMain] = recall.shiftId;
    GlobalDala.cartPayNowDataList[Constant.clientIdMain] = recall.clientId;
    GlobalDala.cartPayNowDataList[Constant.clientNameMain] = recall.clientName;
    GlobalDala.cartPayNowDataList[Constant.phoneNumberMain] =
        recall.phoneNumber;
    GlobalDala.cartPayNowDataList[Constant.subTotalMain] = recall.subTotal ?? 0;
    /*GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] = recall.serviceChargePercentage;*/
    GlobalDala.cartPayNowDataList[Constant.serviceChargeMain] =
        recall.serviceCharge ?? 0;
    GlobalDala.cartPayNowDataList[Constant.orderTotalMain] = recall.orderTotal ?? 0;
    GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain] =
        recall.deliveryCharge ?? 0;

    for (int i = 0; i < (recall.orderDetails?.length ?? 0); i++) {
      GlobalDala.cartData[Constant.id] = recall.orderDetails?[i].id;
      GlobalDala.cartData[Constant.productId] =
          recall.orderDetails?[i].productId;
      GlobalDala.cartData[Constant.productName] = recall.orderDetails?[i].name;
      GlobalDala.cartData[Constant.quantity] = recall.orderDetails?[i].quantity;
      GlobalDala.cartData[Constant.price] = recall.orderDetails?[i].price;
      GlobalDala.cartData[Constant.lineNo] = recall.orderDetails?[i].lineNo;
      GlobalDala.cartData[Constant.note] =
          getNote(recall.orderDetails?[i].fullDescription ?? "");

      GlobalDala.cartData[Constant.variationsPrice] =
          recall.orderDetails?[i].variationsPrice;
      GlobalDala.cartData[Constant.actualPrice] =
          recall.orderDetails?[i].actualprice;
      GlobalDala.cartData[Constant.totalUnitPrice] =
          recall.orderDetails?[i].totalUnitPrice;
      GlobalDala.cartData[Constant.subTotal] = recall.orderDetails?[i].subTotal;
      GlobalDala.cartData[Constant.fullDescription] =
          recall.orderDetails?[i].fullDescription;
      GlobalDala.cartData[Constant.printToKitchen1] =
          recall.orderDetails?[i].printToKitchen1;
      GlobalDala.cartData[Constant.printToKitchen2] =
          recall.orderDetails?[i].printToKitchen2;
      GlobalDala.cartData[Constant.printToKitchen3] =
          recall.orderDetails?[i].printToKitchen3;
      GlobalDala.cartData[Constant.printToKitchen4] =
          recall.orderDetails?[i].printToKitchen4;
      GlobalDala.cartData[Constant.printToKitchen5] =
          recall.orderDetails?[i].printToKitchen5;
      GlobalDala.cartData[Constant.taxId1] = recall.orderDetails?[i].taxId1;
      GlobalDala.cartData[Constant.taxId2] = recall.orderDetails?[i].taxId2;
      GlobalDala.cartData[Constant.taxId3] = recall.orderDetails?[i].taxId3;
      GlobalDala.cartData[Constant.taxId4] = recall.orderDetails?[i].taxId4;
      GlobalDala.cartData[Constant.taxId5] = recall.orderDetails?[i].taxId5;
      GlobalDala.cartData[Constant.taxId6] = recall.orderDetails?[i].taxId6;
      GlobalDala.cartData[Constant.taxRate1] = recall.orderDetails?[i].taxRate1;
      GlobalDala.cartData[Constant.taxRate2] = recall.orderDetails?[i].taxRate2;
      GlobalDala.cartData[Constant.taxRate3] = recall.orderDetails?[i].taxRate3;
      GlobalDala.cartData[Constant.taxRate4] = recall.orderDetails?[i].taxRate4;
      GlobalDala.cartData[Constant.taxRate5] = recall.orderDetails?[i].taxRate5;
      GlobalDala.cartData[Constant.taxRate6] = recall.orderDetails?[i].taxRate6;
      GlobalDala.cartData[Constant.taxPerUnit1] =
          recall.orderDetails?[i].taxPerUnit1;
      GlobalDala.cartData[Constant.taxPerUnit2] =
          recall.orderDetails?[i].taxPerUnit2;
      GlobalDala.cartData[Constant.taxPerUnit3] =
          recall.orderDetails?[i].taxPerUnit3;
      GlobalDala.cartData[Constant.taxPerUnit4] =
          recall.orderDetails?[i].taxPerUnit4;
      GlobalDala.cartData[Constant.taxPerUnit5] =
          recall.orderDetails?[i].taxPerUnit5;
      GlobalDala.cartData[Constant.taxPerUnit6] =
          recall.orderDetails?[i].taxPerUnit6;
      GlobalDala.cartData[Constant.totalTax1] =
          recall.orderDetails?[i].totalTax1;
      GlobalDala.cartData[Constant.totalTax2] =
          recall.orderDetails?[i].totalTax2;
      GlobalDala.cartData[Constant.totalTax3] =
          recall.orderDetails?[i].totalTax3;
      GlobalDala.cartData[Constant.totalTax4] =
          recall.orderDetails?[i].totalTax4;
      GlobalDala.cartData[Constant.totalTax5] =
          recall.orderDetails?[i].totalTax5;
      GlobalDala.cartData[Constant.totalTax6] =
          recall.orderDetails?[i].totalTax6;
      GlobalDala.cartData[Constant.itemTotal] =
          recall.orderDetails?[i].itemTotal;
      GlobalDala.cartData[Constant.selectedItemsLevel] =
          recall.orderDetails?[i].selectedItemsLevel;
      GlobalDala.cartData[Constant.status] = "modified";

      cartDataList.add(json.encode(GlobalDala.cartData));
      // GlobalDala.cartDataListHold?.add(json.encode(GlobalDala.cartData) as Map<String, dynamic>);
    }
    /*   GlobalDala.cartDataListHold = cartDataList
        .map<Map<String, dynamic>>(
          (record) => json.decode(record) as Map<String, dynamic>,).toList();*/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cartDataList', cartDataList);
    GlobalDala.itemCount = cartDataList.length;
  }

  String getNote(String desc) {
    String afterDoubleAsterisk = "";
    int index = desc.indexOf('**');

    // Check if "**" is found and extract the substring after it
    if (index != -1 && index + 2 < desc.length) {
      afterDoubleAsterisk = desc.substring(index + 2);
    }

    return afterDoubleAsterisk;
  }
}
