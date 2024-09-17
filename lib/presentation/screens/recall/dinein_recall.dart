import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../data/models/dineintable_model.dart';
import '../../../data/models/recall_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../global.dart';
import '../home/home.dart';

class DineInRacall extends StatefulWidget {
  final DineInTableModel table;

  DineInRacall(this.table);

  @override
  State<DineInRacall> createState() => _DineInRacallState();
}

class _DineInRacallState extends State<DineInRacall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Info'),
      ),
      body:
      Column(
    children: [
    Expanded(
    child:  SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text('')),
            DataColumn(label: Text('Order No')),
            DataColumn(label: Text('User ID')),
            DataColumn(label: Text('User Name')),
          ],
          rows: widget.table.tableOrdersInfo!.map((order) {
            return DataRow(cells: [
              DataCell(
                IconButton(
                  // Add icon button for edit
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Add your logic here to handle edit action
                    // For example, navigate to edit screen or show dialog
                    // You can use 'recall' object to access row details
                    _handleEdit(order.orderNo);
                  },
                ),
              ),
              DataCell(Text(order.orderNo ?? '')),
              DataCell(Text(order.userId ?? '')),
              DataCell(Text(order.userName ?? '')),
            ]);
          }).toList(),
        ),
      ),
    ),
    ),
    SizedBox(height: 10.0),
      ElevatedButton(
        onPressed: () {


          int guestNumber = 0; // Default value
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              guestNumber = int.tryParse(value) ?? 0;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Number of Guests',
                            errorText: guestNumber > widget.table.seatsNumber ? 'Maximum guest allowed is: ${widget.table.seatsNumber}' : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {

                            if(guestNumber <= widget.table.seatsNumber && guestNumber > 0)
                            {


                              GlobalDala.cartPayNowDataList[Constant.tableIdMain] =widget.table.id;
                              GlobalDala.cartPayNowDataList[Constant.tableNameMain] =widget.table.name;
                              GlobalDala.cartPayNowDataList[Constant.guestNoMain] =guestNumber;
                              GlobalDala.cartPayNowDataList[Constant.tableInfoMain] =widget.table.tableDescription;

                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => home("dineInRecall")));


                            }
                            else
                            {
                              showSnackBarInDialog(context, "Enter valid guest number.!");
                            }

                          },
                          child: Text('Done'),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );

        },
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(AppColors.appColor),
        ),
        child: const Text('    Add New Order    ',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    ],)

    );
  }

  Future<void> _handleEdit(String? orderNo) async {
    List<RecallModel> RecallModelList= await HomeRepository().getOrderlistForRecallDineIn(orderNo);
    for (RecallModel recallModel in RecallModelList) {
      setOrderData(recallModel);
    }
  }

  Future<void> setOrderData(RecallModel recall) async {
    List<String>? cartDataList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalDala.cartPayNowDataList[Constant.idMain] = recall.id;
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
    GlobalDala.cartPayNowDataList[Constant.subTotalMain] = recall.subTotal;
    /*GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] = recall.serviceChargePercentage;*/
    GlobalDala.cartPayNowDataList[Constant.serviceChargeMain] =
        recall.serviceCharge ?? 0;
    GlobalDala.cartPayNowDataList[Constant.orderTotalMain] = recall.orderTotal;
    GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain] =
        recall.deliveryCharge ?? 0;

    for (int i = 0; i < (recall.orderDetails?.length ?? 0); i++) {
      GlobalDala.cartData[Constant.id] = recall.orderDetails?[i].id;
      GlobalDala.cartData[Constant.productId] = recall.orderDetails?[i].productId;
      GlobalDala.cartData[Constant.productName] = recall.orderDetails?[i].name;
      GlobalDala.cartData[Constant.quantity] = recall.orderDetails?[i].quantity;
      GlobalDala.cartData[Constant.price] = recall.orderDetails?[i].price;
      GlobalDala.cartData[Constant.lineNo] = recall.orderDetails?[i].lineNo;
      GlobalDala.cartData[Constant.note] = getNote(recall.orderDetails?[i].fullDescription ?? "");
      GlobalDala.cartData[Constant.variationsPrice] = recall.orderDetails?[i].variationsPrice;
      GlobalDala.cartData[Constant.actualPrice] = recall.orderDetails?[i].actualprice;
      GlobalDala.cartData[Constant.totalUnitPrice] = recall.orderDetails?[i].totalUnitPrice;
      GlobalDala.cartData[Constant.subTotal] = recall.orderDetails?[i].subTotal;
      GlobalDala.cartData[Constant.fullDescription] = recall.orderDetails?[i].fullDescription;
      GlobalDala.cartData[Constant.printToKitchen1] = recall.orderDetails?[i].printToKitchen1;
      GlobalDala.cartData[Constant.printToKitchen2] = recall.orderDetails?[i].printToKitchen2;
      GlobalDala.cartData[Constant.printToKitchen3] = recall.orderDetails?[i].printToKitchen3;
      GlobalDala.cartData[Constant.printToKitchen4] = recall.orderDetails?[i].printToKitchen4;
      GlobalDala.cartData[Constant.printToKitchen5] = recall.orderDetails?[i].printToKitchen5;
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
      GlobalDala.cartData[Constant.taxPerUnit1] = recall.orderDetails?[i].taxPerUnit1;
      GlobalDala.cartData[Constant.taxPerUnit2] = recall.orderDetails?[i].taxPerUnit2;
      GlobalDala.cartData[Constant.taxPerUnit3] = recall.orderDetails?[i].taxPerUnit3;
      GlobalDala.cartData[Constant.taxPerUnit4] = recall.orderDetails?[i].taxPerUnit4;
      GlobalDala.cartData[Constant.taxPerUnit5] = recall.orderDetails?[i].taxPerUnit5;
      GlobalDala.cartData[Constant.taxPerUnit6] = recall.orderDetails?[i].taxPerUnit6;
      GlobalDala.cartData[Constant.totalTax1] = recall.orderDetails?[i].totalTax1;
      GlobalDala.cartData[Constant.totalTax2] = recall.orderDetails?[i].totalTax2;
      GlobalDala.cartData[Constant.totalTax3] = recall.orderDetails?[i].totalTax3;
      GlobalDala.cartData[Constant.totalTax4] = recall.orderDetails?[i].totalTax4;
      GlobalDala.cartData[Constant.totalTax5] = recall.orderDetails?[i].totalTax5;
      GlobalDala.cartData[Constant.totalTax6] = recall.orderDetails?[i].totalTax6;
      GlobalDala.cartData[Constant.itemTotal] = recall.orderDetails?[i].itemTotal;
      GlobalDala.cartData[Constant.selectedItemsLevel] = recall.orderDetails?[i].selectedItemsLevel;
      GlobalDala.cartData[Constant.status] = "modified";

      cartDataList.add(json.encode(GlobalDala.cartData));
    }
    prefs.setStringList('cartDataList', cartDataList);
    GlobalDala.itemCount=cartDataList.length;
    Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (context) => home("dineInRecall")));
  }
  String getNote(String desc) {

    String afterDoubleAsterisk ="";
    int index = desc.indexOf('**');

    // Check if "**" is found and extract the substring after it
    if (index != -1 && index + 2 < desc.length) {
      afterDoubleAsterisk = desc.substring(index + 2);

    }

    return afterDoubleAsterisk;
  }
}