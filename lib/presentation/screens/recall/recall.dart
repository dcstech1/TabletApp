import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/data/Repository/HomeModuleRepository.dart';
import 'package:tabletapp/presentation/Widgets/dialog_helper.dart';
import 'package:tabletapp/presentation/screens/dinein/bartab_screen.dart';
import 'package:tabletapp/presentation/screens/dinein/dine_in.dart';
import 'package:tabletapp/presentation/screens/home/home.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/Repository/UserRepository.dart';
import '../../../data/models/recall_model.dart';
import '../../../data/models/submit_order.dart';
import '../../../data/models/tablegroup_model.dart';
import '../../../data/models/user_details_model.dart';
import '../../../utils/constant.dart';
import '../cart/cart.dart';
import '../delivery/delivery.dart';
import '../global.dart';
import '../pickup/pick_up.dart';

class recall extends StatefulWidget {
  @override
  // _YourListViewWidgetState createState() => _YourListViewWidgetState();
  YourPageWidget createState() => YourPageWidget();
}

class YourPageWidget extends State<recall> {
  RecallModel? _selectedRecall;
  int _selectedIndex = -1;

   List<String> orderTypeArrayList = <String>[];
  late List<TableGroupModel> tableGroupModelList;
  @override
  void initState()  {
    super.initState();
    _checkStaffBankStatus();

  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Orders'),
      ),
      body: FutureBuilder<List<RecallModel>>(
        future: HomeRepository().getOrderlistForRecall(GlobalDala.cartPayNowDataList[Constant.userIdMain]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else {
            final recallList = snapshot.data!;

            print('recallList ${recallList.length}');
            if(recallList.isNotEmpty && recallList.length > 0)
              {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),
                                DataColumn(
                                    label: Text(
                                      'INV. No',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),
                                DataColumn(
                                    label: Text(
                                      'Token',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),
                                DataColumn(
                                    label: Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),

                                DataColumn(
                                    label: Text(
                                      'Server Name',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),

                                DataColumn(
                                    label: Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),
                                DataColumn(
                                    label: Text(
                                      'Type',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),
                                DataColumn(
                                    label: Text(
                                      'Time',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),
                                DataColumn(
                                    label: Text(
                                      'Phone',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    )),

                                // Add edit column
                              ],
                              rows: recallList.map((recall) {
                                final index = recallList.indexOf(recall);
                                final isSelected = index == _selectedIndex;

                                return DataRow.byIndex(
                                  index: index,
                                  selected: isSelected,
                                  onSelectChanged: (selected) {
                                    setState(() {
                                      if (isSelected) {
                                        // If already selected, deselect
                                        _selectedIndex = -1;
                                        _selectedRecall = null;
                                      } else {
                                        // If not selected, select
                                        _selectedIndex = index;
                                        _selectedRecall = recall;

                                        // showSnackBarInDialog(context, "${recall.tokenNumber}");
                                      }
                                    });
                                  },
                                  color: isSelected
                                      ? MaterialStateColor.resolveWith(
                                          (states) => Colors.blue.shade500)
                                      : MaterialStateColor.resolveWith(
                                          (states) => Colors.transparent),
                                  cells: [
                                    DataCell(
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _handleEdit(recall);
                                        },
                                      ),
                                    ),
                                    DataCell(
                                        _buildSingleLineText(recall.orderNumber.toString())),
                                    DataCell(_buildSingleLineText(
                                        recall.tokenNumber.toString())),
                                    DataCell(_buildSingleLineText(
                                        recall.clientName ?? '')),
                                    DataCell(_buildSingleLineText(
                                        recall.serverName ?? '')),
                                    DataCell(_buildSingleLineText(
                                        (recall.orderTotal ?? 0.00).toStringAsFixed(2))),
                                    DataCell(_buildSingleLineText(
                                        recall.orderType == "DineIn"
                                            ? (recall.orderType ?? '') +
                                            " ( ${(recall.tableName ?? '')} )"
                                            : (recall.orderType ?? ''))),
                                    DataCell(_buildSingleLineText(
                                        '${recall.onDate ?? ''} | ${recall.onTime ?? ''}')),
                                    DataCell(_buildSingleLineText(
                                        recall.phoneNumber ?? '')),
                                  ],
                                );
                              }).toList(),
                            ),
                          )),
                    ),
                    SizedBox(height: 10.0),
                    if (isLoading)
                      Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
                        ),
                      ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: ()  {
                            if(userdetail?.isStaffBankEnabled == 1 && userdetail?.staffBankStatus == "CLOSE")
                            {
                              showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {

                                return;
                              });
                            }
                            else
                              {
                                if (_selectedRecall != null) {

                                  orderTypeArrayList = GlobalDala.orderTypeArray
                                      .where((orderType) => orderType != "Recall Delivery")
                                      .toList();
                                  orderTypeArrayList.remove(_selectedRecall?.orderType);

                                  _showOrderTypeDialog(context, _selectedRecall);
                                } else {
                                  showSnackBarInDialog(context, "Select order first.!");
                                }
                              }


                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.appColor),
                          ),
                          child: const Text(' Change OrderType ',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () async {
                            if(userdetail?.isStaffBankEnabled == 1 && userdetail?.staffBankStatus == "CLOSE")
                            {
                              showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {

                                return;
                              });
                            }
                            else
                              {
                                if (_selectedRecall != null) {
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Are you sure to void the order?'),
                                            SizedBox(height: 20),
                                            TextField(
                                              controller: descriptionController,
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
                                      _handelVoid(_selectedRecall!.id);
                                    }
                                  }
                                } else {
                                  showSnackBarInDialog(context, "Select order first.!");
                                }
                              }



                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.appColor),
                          ),
                          child: const Text('    VOID    ',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ],
                    )
                  ],
                );
              }
            return Center(
              child: Container(

                child: Text("No order found!",style: TextStyle(fontSize: 20),),
              ),
            );
          }
        },
      ),
    );
  }

  String newOrderType = "",

      newTableName = "",
      newTableInfo = "",
      newClientName = "",
      newMobileNo = "",
      newGuestNo = "0";

  int newClientId=0, newTableId = 0;
  double newDeliveryCharge = 0.0, newTotalAmount = 0.0;


  void _showOrderTypeDialog(BuildContext context, RecallModel? recall) async {
    int? selectedIndex;
    bool loading = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Order Type'),
              content: Container(
                width: double.maxFinite,
                height: 250, // Fixed height for the container
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: orderTypeArrayList.length - 1,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(orderTypeArrayList[index]),
                                tileColor: selectedIndex == index
                                    ? Colors.blue.withOpacity(0.2)
                                    : null,
                                onTap: () async {
                                  selectedIndex = index;
                                  setState(() {
                                    loading = true;
                                  });

                                  // Simulate some processing time
                                  await Future.delayed(Duration(milliseconds: 200));

                                  //   Navigator.of(context).pop(); // Close the dialog

                                  if (orderTypeArrayList[index] != recall?.orderType) {
                                    newOrderType = orderTypeArrayList[index];

                                    if ((orderTypeArrayList[index] == "DriveThru" || orderTypeArrayList[index] == "TO GO" || orderTypeArrayList[index] == "TO STAY") && mounted) {

                                      _selectedIndex = -1;
                                      _selectedRecall = null;
                                      newTableId = 0;
                                      newTableName = "";
                                      newTableInfo = "$newOrderType Customer Name:${recall?.clientName}";
                                      newGuestNo = "0";
                                      newClientId =   recall?.clientId;
                                      newClientName = recall?.clientName ?? '';
                                      newMobileNo = recall?.phoneNumber ?? '';

                                      newDeliveryCharge = 0.0;
                                      newTotalAmount = (recall?.orderTotal ?? 0.0) - (recall?.deliveryCharge ?? 0.0);
                                      _handelChangeOrderType(recall!);
                                    }
                                    else if (orderTypeArrayList[index] == "Delivery") {

                                      GlobalDala.isOrderTypeEdit = true;

                                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryForm()),);

                                      if (result != null && mounted) {
                                        _selectedIndex = -1;
                                        _selectedRecall = null;
                                        newTableId = 0;
                                        newTableName = "";
                                        newTableInfo = "$newOrderType Customer Name : ${GlobalDala.cartPayNowDataList[Constant.clientNameMain]}";
                                        newGuestNo = "0";
                                        newClientId = GlobalDala.cartPayNowDataList[Constant.clientIdMain];
                                        newClientName = GlobalDala.cartPayNowDataList[Constant.clientNameMain];
                                        newMobileNo = GlobalDala.cartPayNowDataList[Constant.phoneNumberMain];
                                        newDeliveryCharge = GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain];
                                        newTotalAmount = (recall?.orderTotal ?? 0.0) + (newDeliveryCharge ?? 0.0);
                                        _handelChangeOrderType(recall!);
                                      }
                                    }
                                    else if (orderTypeArrayList[index] == "PICKUP") {
                                      GlobalDala.isOrderTypeEdit = true;

                                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => PickUpForm()),);

                                      if (result != null && mounted) {
                                        _selectedIndex = -1;
                                        _selectedRecall = null;
                                        newTableId = 0;
                                        newTableName = "";
                                        newTableInfo = "$newOrderType Customer Name:${GlobalDala.cartPayNowDataList[Constant.clientNameMain]}";
                                        newGuestNo = "0";
                                        newClientId = GlobalDala.cartPayNowDataList[Constant.clientIdMain];
                                        newClientName = GlobalDala.cartPayNowDataList[Constant.clientNameMain];
                                        newMobileNo = GlobalDala.cartPayNowDataList[Constant.phoneNumberMain];
                                        newDeliveryCharge = 0.0;
                                        newTotalAmount = (recall?.orderTotal ?? 0.0) - (recall?.deliveryCharge ?? 0.0);
                                        _handelChangeOrderType(recall!);
                                      }
                                    }
                                    else if (orderTypeArrayList[index] == "DineIn" && mounted) {
                                      GlobalDala.isOrderTypeEdit = true;
                                      getTableGroup(recall);


                                    }
                                    else if (orderTypeArrayList[index] == "BarTab" && mounted) {

                                      final TextEditingController _nameController = TextEditingController();

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

                                              ],
                                            ),

                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  if (_nameController.text == "") {
                                                    showSnackBarInDialog(
                                                        context, "Enter Bar Tab Name.!");
                                                    return;
                                                  } else {
                                                    Navigator.of(context).pop();
                                                    _selectedIndex = -1;
                                                    _selectedRecall = null;
                                                    newTableId = 0;
                                                    newTableName = _nameController.text;
                                                    newTableInfo = "$newOrderType Customer Name:${recall?.clientName}";
                                                    newGuestNo = "0";
                                                    newClientId =   recall?.clientId;
                                                    newClientName = recall?.clientName ?? '';
                                                    newMobileNo = recall?.phoneNumber ?? '';

                                                    newDeliveryCharge = 0.0;
                                                    newTotalAmount = (recall?.orderTotal ?? 0.0) - (recall?.deliveryCharge ?? 0.0);
                                                    _handelChangeOrderType(recall!);
                                                  }
                                                },
                                                child: Text('Done'),
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


                                    }
                                  } else {
                                    showSnackBarInDialog(context, "Select other order type");
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10), // Space below the list
                      ],
                    ),

                  ],
                ),
              ),
              actions: <Widget>[
                if (loading)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      Container(
                        width: 30,
                        height: 30,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
                        ),
                      )

                    ),
                  ),

                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      },
    );
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


  Future<void> getTableGroup( RecallModel? recall)
  async {

    tableGroupModelList = await HomeRepository().getTableGroup();
    try {
      if(tableGroupModelList.isNotEmpty)
      {

        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => dine_in(tableGroupModelList)),);
        if (result != null && mounted) {
          _selectedIndex = -1;
          _selectedRecall = null;

          newClientId =   recall?.clientId;
          newClientName = recall?.clientName ?? '';
          newMobileNo = recall?.phoneNumber ?? '';
          newTableId = GlobalDala.cartPayNowDataList[Constant.tableIdMain];
          newTableName = GlobalDala.cartPayNowDataList[Constant.tableNameMain];
          newTableInfo = GlobalDala.cartPayNowDataList[Constant.tableInfoMain];
          newGuestNo = GlobalDala.cartPayNowDataList[Constant.guestNoMain].toString();
          newDeliveryCharge = 0.0;
          newTotalAmount = (recall?.orderTotal ?? 0.0) - (recall?.deliveryCharge ?? 0.0);
          _handelChangeOrderType(recall!);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  TextEditingController descriptionController = TextEditingController();

  Future<void> _handelChangeOrderType(RecallModel recall) async {
    try {
      SubmitOrderModel? submitOrderModel;
      final Map<String, dynamic> requestData = {
            "id": recall.id,
            "orderType": newOrderType,
            "tableId": newTableId,
            "tableName": newTableName,
            "tableInfo": newTableInfo,
            "guestNo": newGuestNo,
            "paymentType": recall.paymentType,
            "userId": recall.userId,
            "clientId": newClientId,
            "clientName": newClientName,
            "phoneNumber": newMobileNo,
            "onDate": recall.onDate,
            "onTime": recall.onTime,
            "voidreason": "",
            "taxId1": recall.taxId1,
            "taxId2": recall.taxId2,
            "taxId3": recall.taxId3,
            "taxId4": recall.taxId4,
            "taxId5": recall.taxId5,
            "taxId6": recall.taxId6,
            "totalTax1": recall.totalTax1,
            "totalTax2": recall.totalTax2,
            "totalTax3": recall.totalTax3,
            "totalTax4": recall.totalTax4,
            "totalTax5": recall.totalTax5,
            "totalTax6": recall.totalTax6,
            "stationId": recall.stationId,
            "subTotal": recall.subTotal,
            "serviceChargePercentage": recall.serviceChargePercentage,
            "serviceCharge": recall.serviceCharge,
            "deliveryCharge": newDeliveryCharge,
            "orderTotal": newTotalAmount,
           // "OrderDetails": recall.orderDetails,
            "OrderDetails": recall.orderDetails,
            "locId": recall.locId,
            "shiftId": recall.shiftId
          };
print(" requestData $requestData");

      submitOrderModel = await HomeRepository().postSubmitOrder(body: requestData);

      if(submitOrderModel !=null)
            {
              Navigator.of(context).pop();
              setState(() {

              });
              showSnackBarInDialogClose(context,
                  "${submitOrderModel?.statusMessage}",
                      () {

                  });
            }
          else
            {
              showSnackBarInDialog(context, "Unable to change order type, Try again.! ");
            }
    } catch (e) {
      print("Change OrderType Error : $e");
      showSnackBarInDialog(context, "Unable to change order type, Try again.! ");
    }

  }

  Future<void> _handelVoid(int orderId) async {
    try {
     // SubmitOrderModel? submitOrderModel;
      final Map<String, dynamic> requestData = {
            "orderid": orderId,
            "voidreason": descriptionController.text ?? "",
          };
      final result = await HomeRepository().postVoidOrder(body: requestData);

      if (result is Map<String, dynamic> && result.containsKey('error')) {
        showSnackBarInDialog(context, '${result['error']}');
      } else if (result is SubmitOrderModel) {
        setState(() {
          _selectedIndex = -1;
          _selectedRecall = null;
        });
        showSnackBarInDialog(context, 'Order voided successfully');
      }
      else
        {
          showSnackBarInDialog(context, "Unable to void order. Please try again.");
        }

    } catch (e) {
      print("void order error : $e");
      showSnackBarInDialog(context, "Unable to void order. Please try again.");

    }
  }
  UserDetailsModel? userdetail;
  Future<void> _checkStaffBankStatus() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    userdetail = await UserRepository().getloginAccess(codeAccess: prefs.getString('accessCode'));
  }
  void _handleEdit(RecallModel recall) {
    if(userdetail?.isStaffBankEnabled == 1 && userdetail?.staffBankStatus == "CLOSE")
    {
      showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {

        return;
      });
    }
    else
      {
        setOrderData(recall);
        Navigator.of(context).pop();
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) => cart()));
      }

  }

  Future<void> setOrderData(RecallModel recall) async {


   Constant.tokenNumber = recall.tokenNumber;
   Constant.orderNumber = recall.orderNumber;

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
    GlobalDala.cartPayNowDataList[Constant.subTotalMain] = recall.subTotal;
    GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] =
        recall.serviceChargePercentage ?? 0;
    GlobalDala.cartPayNowDataList[Constant.serviceChargeMain] =
        recall.serviceCharge ?? 0;
    GlobalDala.cartPayNowDataList[Constant.orderTotalMain] = recall.orderTotal ?? 0.00;
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
      GlobalDala.cartData[Constant.note] = getNote(recall.orderDetails?[i].fullDescription ?? "");

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
    GlobalDala.cartDataListHold = cartDataList
        .map<Map<String, dynamic>>(
          (record) => json.decode(record) as Map<String, dynamic>,).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cartDataList', cartDataList);
    GlobalDala.itemCount = cartDataList.length;
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
}
