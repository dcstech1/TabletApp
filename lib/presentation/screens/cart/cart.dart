import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/core/theme/app_colors.dart';
import 'package:tabletapp/data/models/submit_order.dart';
import 'package:tabletapp/presentation/screens/cart/paymentscreen.dart';
import 'package:tabletapp/presentation/screens/global.dart';
import 'package:tabletapp/presentation/screens/home/home.dart';
import 'package:tabletapp/utils/constant.dart';

import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../data/Repository/UserRepository.dart';
import '../../../data/models/user_details_model.dart';
import '../../../data/models/variations_model.dart';
import '../../Widgets/dialog_helper.dart';
import '../../Widgets/material_textform_field.dart';
import '../orderflow/qty_screen.dart';
import '../orderflow/variation_screen.dart';
import '../recall/recall.dart';

class cart extends StatefulWidget {
  @override
  _YourListViewWidgetState createState() => _YourListViewWidgetState();
}

// For recall click voidoreder -> main status VOID (other same)  remove (order status removed - don't show in cart ) edit - status modified
class _YourListViewWidgetState extends State<cart> {
  TextEditingController deliveryChargeController = TextEditingController();
  double totalAmount = 0.0, subtotal = 0.0;
  bool isLoading = false;
  List<Map<String, dynamic>> cartDataListSubmit = [];
  double taxValue1 = 0.0;
  double taxValue2 = 0.0;
  double taxValue3 = 0.0;
 int orderId=0;
  Future<void> getDataFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? cartDataList = prefs.getStringList('cartDataList');
    print("cart open list size ${cartDataList?.length}");
    if (cartDataList != null) {
      GlobalDala.cartDataList = cartDataList
          .map<Map<String, dynamic>>(
            (record) => json.decode(record) as Map<String, dynamic>,
          )
          .where((map) =>
              map['status'] !=
              'removed') // Filter out items where status is not 'new'
          .toList();
      cartDataListSubmit = cartDataList
          .map<Map<String, dynamic>>(
            (record) => json.decode(record) as Map<String, dynamic>,
          )
          .toList();
    }

    GlobalDala.itemCount = GlobalDala.cartDataList.length;
    //manage main tax data
    GlobalDala.cartPayNowDataList[Constant.taxId1Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.taxId2Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.taxId3Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.totalTax1Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.totalTax2Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.totalTax3Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.subTotalMain] = 0;
    for (Map<String, dynamic> cartData in GlobalDala.cartDataList) {
      print('Name : ${cartData[Constant.status]}');
      if (cartData[Constant.taxId1] == 1) {
        GlobalDala.cartPayNowDataList[Constant.taxId1Main] = 1;
      }
      if (cartData[Constant.taxId2] == 2) {
        GlobalDala.cartPayNowDataList[Constant.taxId2Main] = 2;
      }
      if (cartData[Constant.taxId3] == 3) {
        GlobalDala.cartPayNowDataList[Constant.taxId3Main] = 3;
      }
      GlobalDala.cartPayNowDataList[Constant.totalTax1Main] +=
          cartData[Constant.totalTax1];
      GlobalDala.cartPayNowDataList[Constant.totalTax2Main] +=
          cartData[Constant.totalTax2];
      GlobalDala.cartPayNowDataList[Constant.totalTax3Main] +=
          cartData[Constant.totalTax3];

      GlobalDala.cartPayNowDataList[Constant.subTotalMain] +=
          cartData[Constant.subTotal];
    }

    GlobalDala.cartPayNowDataList[Constant.orderTotalMain] =
        ((GlobalDala.cartPayNowDataList[Constant.subTotalMain] ?? 0.0) +
                (GlobalDala.cartPayNowDataList[Constant.totalTax1Main] ?? 0.0) +
                (GlobalDala.cartPayNowDataList[Constant.totalTax2Main] ?? 0.0) +
                (GlobalDala.cartPayNowDataList[Constant.totalTax3Main] ?? 0.0) )
            .toStringAsFixed(2);

    if(GlobalDala.cartPayNowDataList[Constant.serviceChargeMain] > 0 )
    {
      _applyServiceCharge = true;
      subtotal = calculateSubtotal();
      serviceAmount = ((subtotal *
          (GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] ?? GlobalDala.homeModel?.serviceChargeAmount)) /
          100);
    }
  }

  Future<void> deleteCartItem(int index, BuildContext context) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    // Perform deletion only if confirmed
    if (confirmDelete == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (index >= 0 && index < GlobalDala.cartDataList.length) {
        Map<String, dynamic> cartItem = GlobalDala.cartDataList[index];
        if (cartItem[Constant.status] == 'modified') {
          cartItem[Constant.status] = 'removed';
          GlobalDala.cartDataList[index] = cartItem;
        } else {
          GlobalDala.cartDataList.removeAt(index);
        }
      }

      List<String> updatedCartDataList = GlobalDala.cartDataList
          .map<String>((item) => json.encode(item))
          .toList();
      prefs.setStringList('cartDataList', updatedCartDataList);

      // Refresh the widget after deletion
      print('After delete size ${updatedCartDataList.length}');
      setState(() {});
    }
  }

  double calculateSubtotal() {
    double subtotal = 0.0;

    for (Map<String, dynamic> cartData in GlobalDala.cartDataList) {
      subtotal += cartData[Constant.subTotal];
    }

    return subtotal;
  }

  double calculateTax() {
    taxValue1 = 0.0;
    taxValue2 = 0.0;
    taxValue3 = 0.0;
    for (Map<String, dynamic> cartData in GlobalDala.cartDataList) {
      taxValue1 += cartData[Constant.taxPerUnit1];
      taxValue2 += cartData[Constant.taxPerUnit2];
      taxValue3 += cartData[Constant.taxPerUnit3];
    }

    return (taxValue1 + taxValue2 + taxValue3 );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkStaffBankStatus();
    if (GlobalDala.cartPayNowDataList[Constant.orderTypeMain] == "Delivery") {
      deliveryChargeController.text =
          (GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain] ?? 0.0)
              .toString();
    }
    GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] = GlobalDala.homeModel?.serviceChargeAmount;
    getDataFromLocal();


    DateTime selectedDate = DateTime.now();
    GlobalDala.cartPayNowDataList[Constant.onDateMain] = DateFormat('dd/MM/yyyy').format(selectedDate.toLocal());
    GlobalDala.cartPayNowDataList[Constant.onTimeMain] = DateFormat('HH:mm:ss').format(selectedDate);
  }

  /*
  return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushNamed(context, "/home");
        } else {
          SystemNavigator.pop();
        }
        return true;
      },*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        Navigator.of(context).pop(true);

        if (!GlobalDala.isRecall) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => home('cart')),
          );
        } else {
          //clean cart because come from recall
          SharedPreferences prefs = await SharedPreferences.getInstance();

          List<String>? cartDataList = [];
          prefs.setStringList('cartDataList', cartDataList);
          GlobalDala.itemCount = cartDataList.length;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => recall()));
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary'),
            SizedBox(height: 5),
            if (GlobalDala.isRecall)
              Text(
                'Token No: ${Constant.tokenNumber}  |  Order No: ${Constant.orderNumber}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
          actions:<Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => home('cart')),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: getDataFromLocal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while data is being loaded
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error if loading fails
              return Center(child: Text('Error loading data'));
            } else {
              // Display the DataTable and Subtotal when data is loaded

              subtotal = calculateSubtotal();
              double taxAmount = calculateTax();

              if (GlobalDala.cartPayNowDataList[Constant.orderTypeMain] ==
                  "Delivery") {
                totalAmount = subtotal +
                    taxAmount +
                    serviceAmount +
                    (GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain] ??
                        0.0);
              } else {
                totalAmount = subtotal + taxAmount + serviceAmount;
              }
              GlobalDala.cartPayNowDataList[Constant.orderTotalMain] = totalAmount;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            dataRowMaxHeight: double.infinity,
                            columns: [
                              DataColumn(label: Text('Product Name')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Qty')),
                              DataColumn(label: Text('Total Price')),
                              DataColumn(label: Text('Delete')),
                              DataColumn(label: Text('Edit')),
                            ],
                            rows: GlobalDala.cartDataList
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> cartData = entry.value;

                              List<dynamic>? serializedSelectedItemsList =
                                  cartData[Constant.selectedItemsLevel];

                              List<Datum> variations = [];
                              List<Widget> variationTextWidgets = [];

                              if (serializedSelectedItemsList != null) {
                                for (dynamic item
                                    in serializedSelectedItemsList) {
                                  variations.add(Datum.fromJson(item));
                                }

                                variationTextWidgets = variations.map((datum) {
                                  return Text('* ${datum.name}',
                                      style: TextStyle(fontSize: 12));
                                }).toList();
                              }

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      // Adjust vertical padding as needed

                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                cartData[Constant.productName]),
                                            SizedBox(height: 4),
                                            ...variationTextWidgets,
                                            if (cartData[Constant.note] !=
                                                    null &&
                                                cartData[Constant.note] != "")
                                              Text(
                                                  '** ${cartData[Constant.note]}'),
                                            SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(_buildSingleLineText(
                                      cartData[Constant.price].toString())),
                                  DataCell(_buildSingleLineText(
                                      cartData[Constant.quantity].toString())),
                                  DataCell(_buildSingleLineText(
                                      cartData[Constant.subTotal].toString())),

                                  /*  DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: variationTextWidgets,
                                ),
                              ),*/
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // Call the delete function when the delete button is pressed
                                        deleteCartItem(index, context);
                                      },
                                    ),
                                  ),
                                  /*DataCell(
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        // Call the delete function when the delete button is pressed
                                        _showDialog(context, index);
                                      },
                                    ),
                                  ),*/
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.edit), // Add edit icon
                                      onPressed: () {
                                        // Call the edit function when the edit button is pressed
                                        editCartItem(index, context, cartData);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        )),
                  ),
                  SizedBox(height: 10.0),

                  serviceChargeWidget(),
                  deliveryChargeWidget(),
                  SizedBox(height: 5), // Add some spacing

                  // Display Subtotal
                  buildBillDetail(
                      'Subtotal:', '\$${subtotal.toStringAsFixed(2)}'),
                  if (GlobalDala.homeModel?.applyServiceCharge == 1 &&
                      _applyServiceCharge)
                    Container(
                      child: buildBillDetail('Service Charge:',
                          '\$${serviceAmount.toStringAsFixed(2)}'),
                    ),

                  // Display Tax
if(GlobalDala.cartPayNowDataList[Constant.taxId1Main] == 1)
                  buildBillDetail(
                    '${GlobalDala.homeModel?.taxes?[0].name} (${GlobalDala.homeModel?.taxes?[0].rate} %):',
                    '\$${taxValue1.toStringAsFixed(2)}',
                  ),
if(GlobalDala.cartPayNowDataList[Constant.taxId2Main] == 2)
                  buildBillDetail(
                    '${GlobalDala.homeModel?.taxes?[1].name} (${GlobalDala.homeModel?.taxes?[1].rate} %):',
                    '\$${taxValue2.toStringAsFixed(2)}',
                  ),
if(GlobalDala.cartPayNowDataList[Constant.taxId3Main] == 3)
                  buildBillDetail(
                    '${GlobalDala.homeModel?.taxes?[2].name} (${GlobalDala.homeModel?.taxes?[2].rate} %):',
                    '\$${taxValue3.toStringAsFixed(2)}',
                  ),

                  // Display Total

                  buildBillDetail(
                      'Total:', '\$${totalAmount.toStringAsFixed(2)}'),
                  const SizedBox(height: 10),
                  if (isLoading)
                    Container(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.appColor),
                      ),
                    ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlobalDala.isRecall
                            ? ElevatedButton(
                                onPressed: () async {

                                  if(userdetail?.isStaffBankEnabled == 1 && userdetail?.staffBankStatus == "CLOSE")
                                  {
                                    showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {

                                      return;
                                    });
                                  }
                                  else

                                    {
                                      if (cartDataListSubmit.isNotEmpty) {
                                        bool confirmDelete = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirmation'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'Are you sure to void the order?'),
                                                  SizedBox(height: 20),
                                                  TextField(
                                                    controller:
                                                    descriptionController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Description',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true); // Confirmed
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false); // Cancel
                                                  },
                                                  child: Text('No'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (confirmDelete == true) {
                                          if (descriptionController.text == "") {
                                            showSnackBarInDialog(
                                                context, "Enter Description.!");
                                          } else {

                                            isPayClick=false;
                                            submitTableOrder(context, "Void");
                                          }
                                        }
                                      } else {
                                        showSnackBarInDialog(
                                            context, "Cart is empty.!");
                                      }
                                    }



                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColors.appColor),
                                ),
                                child: const Text('  VOID  ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              )
                            : SizedBox(),
                        SizedBox(width: 16),
                        GlobalDala.isRecall
                            ? ElevatedButton(
                                onPressed: () async {
                                  if(userdetail?.isStaffBankEnabled == 1 && userdetail?.staffBankStatus == "CLOSE")
                                  {
                                    showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {

                                      return;
                                    });
                                  }
                                  else
                                    {
                                      if (cartDataListSubmit.isNotEmpty) {

                                        if(GlobalDala.isRecall)
                                        {
                                          isPayClick=true;
                                          updateStatus();
                                        }


                                      } else {
                                        showSnackBarInDialog(context, "Cart is empty.!");
                                      }
                                    }


                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColors.appColor),
                                ),
                                child: const Text('  PAY  ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              )
                            : SizedBox(),
                        SizedBox(width: 16),
                        // Add some space between the buttons
                        ElevatedButton(
                          onPressed: () {

                            if(userdetail?.isStaffBankEnabled == 1 && userdetail?.staffBankStatus == "CLOSE")
                            {
                              showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {

                                return;
                              });
                            }
                            else
                              {
                                if (cartDataListSubmit.isNotEmpty) {

                                  isPayClick=false;
                                  if(GlobalDala.isRecall)
                                  {

                                    updateStatus();
                                  }
                                  else
                                  {
                                    submitTableOrder(context, "Submit");
                                  }
                                } else {
                                  showSnackBarInDialog(context, "Cart is empty.!");
                                }
                              }



                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.appColor),
                          ),
                          child: const Text('    Place Order    ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
  UserDetailsModel? userdetail;
  Future<void> _checkStaffBankStatus() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    userdetail = await UserRepository().getloginAccess(codeAccess: prefs.getString('accessCode'));
  }
  Widget _buildSingleLineText(String text) {
    return FittedBox(
      // Adjust width as needed
      child: Text(
        text,
        style: TextStyle(fontSize: 12), // Adjust font size as needed
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _showDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => DialogContent(),
    );
  }




  void updateStatus()
  {


    int index = 0;
    //bool variationListChanged =false;

    for (Map<String, dynamic> originalItem in GlobalDala.cartDataListHold!) {
     // variationListChanged =false;
      Map<String, dynamic> newItem = cartDataListSubmit[index];



      if(newItem[Constant.status]=="modified")
        {
          final deepEq = const DeepCollectionEquality.unordered().equals;

          bool isEqual = deepEq(originalItem[Constant.selectedItemsLevel], newItem[Constant.selectedItemsLevel]);


          if(!isEqual || newItem[Constant.quantity] != originalItem[Constant.quantity])
          {
            print('Variation or Quantity changed............');

            newItem[Constant.status]="modified";
            cartDataListSubmit[index] = newItem;
          }
          else {

            newItem[Constant.status]=" ";
            cartDataListSubmit[index] = newItem;
            print('Nottt changed............');
          }
        }



      index++; // Increment the index for the next iteration
    }

    for (Map<String, dynamic> submit in cartDataListSubmit) {

      print('Fianl submit data status    ::  ${submit[Constant.status]}  ............');
    }
    submitTableOrder(context, "Submit");
  }
  Widget deliveryChargeWidget() {
    if (GlobalDala.cartPayNowDataList[Constant.orderTypeMain] == "Delivery") {
      return Container(
        height: 45,
        margin: EdgeInsets.all(8.0), // Adjust the value as needed
        child:

            TextField(
          controller: deliveryChargeController,
          onChanged: (value) {},
              readOnly: true,
          decoration: InputDecoration(
            labelText: 'Delivery charge:',
            border: OutlineInputBorder(),
          ),
        ),
      );
    } else {
      return SizedBox(); // Return an empty widget if condition is not met
    }
  }

  bool _applyServiceCharge = false;
  bool isPayClick = false;
  double serviceAmount = 0.00;

  Widget serviceChargeWidget() {



    if (GlobalDala.homeModel?.applyServiceCharge == 1) {
      return Container(
        height: 45,
        margin: EdgeInsets.all(8.0), // Adjust the value as needed
        child: Row(
          children: [
            Checkbox(
              value: _applyServiceCharge,
              onChanged: (bool? value) {
                setState(() {
                  _applyServiceCharge = value!;


                  if(_applyServiceCharge)
                    {
                      serviceAmount = ((subtotal *
                          (GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] ?? GlobalDala.homeModel?.serviceChargeAmount)) /
                          100);
                    }
                  else
                    {
                      serviceAmount =0.0;
                    }

                  GlobalDala.cartPayNowDataList[Constant.serviceChargeMain] =
                      serviceAmount;

                });
              },
            ),
            Text('Apply service charge'),
          ],
        ),
      );
    } else {
      return SizedBox(); // Return an empty widget if condition is not met
    }
  }

  TextEditingController descriptionController = TextEditingController();

  SubmitOrderModel? submitOrderModel;

  Future<void> submitTableOrder(BuildContext context, String orderType) async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching data starts
    });
    try {


      if (orderType == "Submit") {
        final Map<String, dynamic> requestData = {
          "id": GlobalDala.cartPayNowDataList[Constant.idMain],
          "orderType": GlobalDala.cartPayNowDataList[Constant.orderTypeMain],
          "tableId": GlobalDala.cartPayNowDataList[Constant.tableIdMain],
          "tableName": GlobalDala.cartPayNowDataList[Constant.tableNameMain],
          "tableInfo": GlobalDala.cartPayNowDataList[Constant.tableInfoMain],
          "guestNo": GlobalDala.cartPayNowDataList[Constant.guestNoMain],
          "paymentType": "onCounter",
          "userId": GlobalDala.cartPayNowDataList[Constant.userIdMain],
          "clientId": GlobalDala.cartPayNowDataList[Constant.clientIdMain],
          "clientName": GlobalDala.cartPayNowDataList[Constant.clientNameMain],
          "phoneNumber": GlobalDala.cartPayNowDataList[Constant.phoneNumberMain],
          "onDate": GlobalDala.cartPayNowDataList[Constant.onDateMain],
          "onTime": GlobalDala.cartPayNowDataList[Constant.onTimeMain],
          "voidreason": descriptionController.text ?? "",
          "taxId1": GlobalDala.cartPayNowDataList[Constant.taxId1Main],
          "taxId2": GlobalDala.cartPayNowDataList[Constant.taxId2Main],
          "taxId3": GlobalDala.cartPayNowDataList[Constant.taxId3Main],
          "taxId4": GlobalDala.cartPayNowDataList[Constant.taxId4Main],
          "taxId5": GlobalDala.cartPayNowDataList[Constant.taxId5Main],
          "taxId6": GlobalDala.cartPayNowDataList[Constant.taxId6Main],
          "totalTax1": GlobalDala.cartPayNowDataList[Constant.totalTax1Main],
          "totalTax2": GlobalDala.cartPayNowDataList[Constant.totalTax2Main],
          "totalTax3": GlobalDala.cartPayNowDataList[Constant.totalTax3Main],
          "totalTax4": GlobalDala.cartPayNowDataList[Constant.totalTax4Main],
          "totalTax5": GlobalDala.cartPayNowDataList[Constant.totalTax5Main],
          "totalTax6": GlobalDala.cartPayNowDataList[Constant.totalTax6Main],
          "stationId": GlobalDala.cartPayNowDataList[Constant.stationIdMain],
          "subTotal": GlobalDala.cartPayNowDataList[Constant.subTotalMain],
          "serviceChargePercentage":
          GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain],
          "serviceCharge":
          GlobalDala.cartPayNowDataList[Constant.serviceChargeMain],
          "deliveryCharge":
          GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain],
          "orderTotal": GlobalDala.cartPayNowDataList[Constant.orderTotalMain],
          "OrderDetails": cartDataListSubmit,
          "locId": GlobalDala.cartPayNowDataList[Constant.locIdMain],
          "shiftId": GlobalDala.cartPayNowDataList[Constant.shiftIdMain]
        };
        log("Submit Order__ = $requestData");
        submitOrderModel = await HomeRepository().postSubmitOrder(body: requestData);
        if (submitOrderModel != null) {

          if(isPayClick)
            {


              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaymentScreen(totalAmount)));
            }
          else
            {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text(
                          ' Order Placed ! Token number #${submitOrderModel?.tokenCode}'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            GlobalDala.cartPayNowDataList.clear();
                            GlobalDala.cartData.clear();
                            GlobalDala.cartDataList.clear();
                            cartDataListSubmit.clear();

                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            List<String>? cartDataList = [];
                            prefs.setStringList('cartDataList', cartDataList);
                            GlobalDala.itemCount = cartDataList.length;

                            if (Navigator.canPop(context)) {
                              Navigator.popUntil(context, (route) => route.isFirst);
                              Navigator.pushNamed(context, "/orderType");
                            } else {
                              SystemNavigator.pop();
                            }
                          },
                          child: Text('CLOSE'),
                        ),
                      ],
                    );
                  },);
            }


        } else {
          showSnackBarInDialog(
              context, "Unable to send data. Please try again.");
        }
      } else if
      (orderType == "Void")
      {

        try {
          final Map<String, dynamic> requestData = {
                    "orderid": GlobalDala.cartPayNowDataList[Constant.idMain],
                    "voidreason": descriptionController.text ?? "",
                  };
          final result = await HomeRepository().postVoidOrder(body: requestData);

          if (result is Map<String, dynamic> && result.containsKey('error')) {
                    showSnackBarInDialog(context, '${result['error']}');
                  }
                  else if (result is SubmitOrderModel) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text(' Order void successfully.!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                GlobalDala.cartPayNowDataList.clear();
                                GlobalDala.cartData.clear();
                                GlobalDala.cartDataList.clear();
                                cartDataListSubmit.clear();

                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                List<String>? cartDataList = [];
                                prefs.setStringList('cartDataList', cartDataList);
                                GlobalDala.itemCount = cartDataList.length;

                                if (Navigator.canPop(context)) {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                  Navigator.pushNamed(context, "/orderType");
                                } else {
                                  SystemNavigator.pop();
                                }
                              },
                              child: Text('CLOSE'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else
                  {
                    showSnackBarInDialog(context, "Unable to void order. Please try again.");
                  }
        } catch (e) {
          print(e);
          showSnackBarInDialog(context, "Unable to void order. Please try again.");

        }

      }
    } catch (e) {
      print('Submit error : ${e.toString()}');
      showSnackBarInDialog(
          context, "An error occurred. Please try again later.");
    } finally {
      setState(() {
        isLoading =
            false; // Set isLoading to false when fetching data completes
      });
    }

    print('submitorder res : ${submitOrderModel.toString()}');
  }

  void editCartItem(

      int index, BuildContext context, Map<String, dynamic> cartData) async {
    // Navigate to the edit screen/dialog

    print('before edit size : ${GlobalDala.cartDataList.length}');
    try {
      List<VariationsModel> variationList =
          await HomeRepository().getVariation(id: cartData[Constant.productId]);

      // Use the data as needed
      GlobalDala.isEdite = true;
      GlobalDala.editIndex = index;

      setCartData(cartData);

      if (variationList.isNotEmpty) {
        // Navigator.of(context).pop(); // This will pop the current route
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => VariationsScreen(variationList)),
        );
      } else {
        //  Navigator.of(context).pop(); // This will pop the current route
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => qty_screen()),
        );
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  void setCartData(Map<String, dynamic> cartData) {
    GlobalDala.cartData[Constant.productId] = cartData[Constant.productId];
    GlobalDala.cartData[Constant.productName] = cartData[Constant.productName];
    GlobalDala.cartData[Constant.actualPrice] = cartData[Constant.actualPrice];
    GlobalDala.cartData[Constant.fullDescription] =
        cartData[Constant.productName];

    GlobalDala.cartData[Constant.taxId1] = cartData[Constant.taxId1];
    GlobalDala.cartData[Constant.taxId2] = cartData[Constant.taxId2];
    GlobalDala.cartData[Constant.taxId3] = cartData[Constant.taxId3];
    GlobalDala.cartData[Constant.note]=cartData[Constant.note];
    GlobalDala.cartData[Constant.id] = cartData[Constant.id];
    GlobalDala.cartData[Constant.printToKitchen1] = cartData[Constant.printToKitchen1];
    GlobalDala.cartData[Constant.printToKitchen2] = cartData[Constant.printToKitchen2];
    GlobalDala.cartData[Constant.printToKitchen3] = cartData[Constant.printToKitchen3];
    GlobalDala.cartData[Constant.printToKitchen4] = cartData[Constant.printToKitchen4];
    GlobalDala.cartData[Constant.printToKitchen5] = cartData[Constant.printToKitchen5];
    GlobalDala.cartData[Constant.taxId4] = cartData[Constant.taxId4];
    GlobalDala.cartData[Constant.taxId5] = cartData[Constant.taxId5];
    GlobalDala.cartData[Constant.taxId6] = cartData[Constant.taxId6];
    GlobalDala.cartData[Constant.taxRate4] = cartData[Constant.taxRate4];
    GlobalDala.cartData[Constant.taxRate5] = cartData[Constant.taxRate5];
    GlobalDala.cartData[Constant.taxRate6] = cartData[Constant.taxRate6];
    GlobalDala.cartData[Constant.taxPerUnit4] = cartData[Constant.taxPerUnit4];
    GlobalDala.cartData[Constant.taxPerUnit5] = cartData[Constant.taxPerUnit5];
    GlobalDala.cartData[Constant.taxPerUnit6] = cartData[Constant.taxPerUnit6];
    GlobalDala.cartData[Constant.totalTax4] = cartData[Constant.totalTax4];
    GlobalDala.cartData[Constant.totalTax5] = cartData[Constant.totalTax5];
    GlobalDala.cartData[Constant.totalTax6] = cartData[Constant.totalTax6];
    GlobalDala.cartData[Constant.status] = cartData[Constant.status];

    GlobalDala.cartData[Constant.taxRate1] = cartData[Constant.taxRate1];
    GlobalDala.cartData[Constant.taxRate2] = cartData[Constant.taxRate2];
    GlobalDala.cartData[Constant.taxRate3] = cartData[Constant.taxRate3];

    GlobalDala.cartData[Constant.variationsPrice] =
        cartData[Constant.variationsPrice] ?? 0.0;
    GlobalDala.cartData[Constant.selectedItemsLevel] =
        cartData[Constant.selectedItemsLevel];


    print('GlobalDala.cartData Edit ${GlobalDala.cartData}');
  }

  Widget buildBillDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14,2,14,2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}

class DialogContent extends StatefulWidget {
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 200,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(child: Text('Content for Tab 1')),
                  Center(child: Text('Content for Tab 2')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
