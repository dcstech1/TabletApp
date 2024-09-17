import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/core/theme/app_colors.dart';
import 'package:tabletapp/data/Repository/HomeModuleRepository.dart';
import 'package:tabletapp/data/Repository/UserRepository.dart';
import 'package:tabletapp/data/models/home_model.dart';
import 'package:tabletapp/presentation/screens/cart/paymentscreen.dart';
import 'package:tabletapp/presentation/screens/delivery/delivery.dart';
import 'package:tabletapp/presentation/screens/dinein/bartab_screen.dart';
import 'package:tabletapp/presentation/screens/dinein/dine_in.dart';
import 'package:tabletapp/presentation/screens/login/login.dart';
import 'package:tabletapp/presentation/screens/pickup/pick_up.dart';
import 'package:tabletapp/presentation/screens/recall/delivery_recall.dart';
import 'package:tabletapp/presentation/screens/recall/recall.dart';

import '../../../core/sharedPrefrences/shared_preference.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/clientdetail_model.dart';
import '../../../data/models/tablegroup_model.dart';
import '../../../data/models/user_details_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../../Widgets/material_button_without_icon.dart';
import '../../Widgets/material_textform_field.dart';
import '../global.dart';
import '../home/home.dart';

class order_type extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderTypeState();
}

class _OrderTypeState extends State<order_type> {
  bool _isLoading = false;
  bool _isLoading2 = false;

  UserDetailsModel? userdetail;
  final TextEditingController accesscodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:() async {




        return false;
      },
      child:  Scaffold(
        appBar: AppBar(
            title: const Text("Order Type"),
            centerTitle: true,
            backgroundColor: AppColors.appColor,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout,size: 30),
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Are you sure to logout?'),

                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Confirmed
                            Navigator.of(context).pop(); // Confirmed
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cancel
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],

        ),

        body: Center(
          child: _isLoading
              ? Container(
            width: 30,
            height: 30,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
            ),
          ) // Display loading indicator if _isLoading is true
              : ListView.builder(
            itemCount: GlobalDala.orderTypeArray.length,
            itemBuilder: (context, index) {
              return Card(
                //                           <-- Card
                child: ListTile(
                  title: Text(GlobalDala.orderTypeArray[index],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.arrow_right),
                  textColor: AppColors.appColor,
                  onTap: () async {
                    GlobalDala.isOrderTypeEdit = false;
                    GlobalDala.cartPayNowDataList[Constant.orderTypeMain] = GlobalDala.orderTypeArray[index];

                    defaultStorage();
                    if(GlobalDala.homeModel?.trackByID == 0)
                      {


                        if (GlobalDala.orderTypeArray[index] == "Delivery") {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeliveryForm()));
                        }
                        else if (GlobalDala.orderTypeArray[index] == "PICKUP") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PickUpForm()));
                        }
                        else if (GlobalDala.orderTypeArray[index] == "RECALL") {

                          GlobalDala.isRecall=true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => recall()));
                        }
                        else if (GlobalDala.orderTypeArray[index] == "DineIn") {

                          getTableGroup();
                        }
                        else if (GlobalDala.orderTypeArray[index] == "Recall Delivery") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecallDelivery()));
                        }
                        else {
                          getClientDetails();
                        }
                      }
                    else
                      {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: accesscodeController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText:
                                      "Enter access code",
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
                                    if (accesscodeController.text == "") {
                                      showSnackBarInDialog(
                                          context, "Enter access code.!");
                                      return;
                                    } else {
                                      setState(() {
                                        _isLoading2 = true; // Set loading state to true before fetching data
                                      });

                                      try {
                                        userdetail = await UserRepository().getloginAccess(codeAccess: accesscodeController.text);

                                        if (userdetail != null) {

                                             if(userdetail?.isStaffBankEnabled==1 && userdetail?.staffBankStatus == "CLOSE")
                                             {
                                               showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {
                                                 accesscodeController.clear();
                                                 Navigator.of(context).pop();

                                                 return;
                                               });
                                             }
                                             else
                                             {

                                               if(GlobalDala.orderTypeArray[index] != "Recall Delivery" && userdetail?.isAdmin == 0 && userdetail?.isDriver == 1)
                                                 {
                                                   showSnackBarInDialogClose(context, "Access denied for driver.!", () {
                                                     accesscodeController.clear();
                                                     Navigator.of(context).pop();

                                                     return;
                                                   });
                                                 }
                                               else if(GlobalDala.orderTypeArray[index] == "Recall Delivery" &&  userdetail?.isDriver == 0)
                                                 {
                                                   showSnackBarInDialogClose(context, "Access denied !", () {
                                                     accesscodeController.clear();
                                                     Navigator.of(context).pop();

                                                     return;
                                                   });
                                                 }
                                               else
                                                 {
                                                   SharedPreferencesHelper.saveUserData(userdetail!);
                                                   await Future.delayed(Duration(milliseconds: 200));

                                                   GlobalDala.cartPayNowDataList[Constant.userIdMain] = userdetail?.id;
                                                   SharedPreferences prefs = await SharedPreferences.getInstance();
                                                   prefs.setString('accessCode', accesscodeController.text.toString());
                                                   accesscodeController.clear();
                                                   Navigator.of(context).pop();


                                                   if (GlobalDala.orderTypeArray[index] == "Delivery") {

                                                     Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                             builder: (context) => DeliveryForm()));
                                                   }
                                                   else if (GlobalDala.orderTypeArray[index] == "PICKUP") {
                                                     Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                             builder: (context) => PickUpForm()));
                                                   }
                                                   else if (GlobalDala.orderTypeArray[index] == "RECALL") {

                                                     GlobalDala.isRecall=true;
                                                     Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                             builder: (context) => recall()));
                                                   }
                                                   else if (GlobalDala.orderTypeArray[index] == "DineIn") {

                                                     getTableGroup();
                                                   }
                                                   else if (GlobalDala.orderTypeArray[index] == "Recall Delivery") {
                                                     Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                             builder: (context) => RecallDelivery()));
                                                   }
                                                   else {
                                                     getClientDetails();
                                                   }

                                                 }


                                             }

                                           } else {
                                             showSnackBarInDialog(context,
                                                 "Invalid access code. Please enter a valid one.");

                                           }
                                      } catch (e) {
                                        print(e);
                                      }
                                      finally{
                                        setState(() {
                                          _isLoading2 = false; // Set loading state to true before fetching data
                                        });
                                      //  Navigator.of(context).pop();
                                      }




                                    }
                                  },
                                  child: Text('Done'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    accesscodeController.clear();
                                    Navigator.of(context).pop(); // Cancel
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      }





                  },
                ),
              );
            },
          ),
        ),
        bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: _isLoading2,
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
                ),
              ),
            ), SizedBox(height: 10),


            // Add some spacing between the indicator and the button

          ],
        ),

      ),
    );

  }

  @override
  void initState() {
    super.initState();
    print('OrderType Init');
    getOrderType();
    //
  }



  @override
  void dispose() {
    super.dispose();
  }

  Future<void> defaultStorage() async {
    GlobalDala.isRecall=false;
    GlobalDala.cartPayNowDataList[Constant.idMain] = 0;
    GlobalDala.cartPayNowDataList[Constant.paymentTypeMain] = "onCounter";
    int? userId = await SharedPreferencesHelper.getUserId();
    GlobalDala.cartPayNowDataList[Constant.userIdMain] = userId;


    GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain] = 0;
    GlobalDala.cartPayNowDataList[Constant.serviceChargeMain] = 0;
    GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] = 0;
    if (GlobalDala.cartPayNowDataList[Constant.orderTypeMain] == "Delivery") {
      GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain] =
          GlobalDala.homeModel?.deliveryCharge;
    }


    GlobalDala.cartPayNowDataList[Constant.taxId4Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.taxId5Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.taxId6Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.totalTax4Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.totalTax5Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.totalTax6Main] = 0;
    GlobalDala.cartPayNowDataList[Constant.stationIdMain] = 0;
    GlobalDala.cartPayNowDataList[Constant.locIdMain] = 0;
    GlobalDala.cartPayNowDataList[Constant.shiftIdMain] = 0;





    GlobalDala.cartPayNowDataList[Constant.tableIdMain] = 0;
    GlobalDala.cartPayNowDataList[Constant.tableNameMain] = "";
    GlobalDala.cartPayNowDataList[Constant.guestNoMain] =0;
  }

  Future<void> getClientDetails() async {
     setState(() {
       _isLoading2 = true; // Set loading state to true before fetching data
    });

    try {
      GlobalDala.clientDetailModel =
          await HomeRepository().getClientDetailFromTakeAway();
      print('getClientDetails : ${GlobalDala.clientDetailModel.toString()}');

      if (GlobalDala.clientDetailModel != null) {

        GlobalDala.cartPayNowDataList[Constant.clientIdMain] = GlobalDala.clientDetailModel?.clientId;
        GlobalDala.cartPayNowDataList[Constant.clientNameMain] = GlobalDala.clientDetailModel?.firstName;
        GlobalDala.cartPayNowDataList[Constant.phoneNumberMain] = GlobalDala.clientDetailModel?.phoneNo;
        GlobalDala.cartPayNowDataList[Constant.tableInfoMain] = "${GlobalDala.cartPayNowDataList[Constant.orderTypeMain]}  Customer Name:${GlobalDala.cartPayNowDataList[Constant.clientNameMain]}";
        if(GlobalDala.cartPayNowDataList[Constant.orderTypeMain]=="DineIn")
          {
            //GlobalDala.cartPayNowDataList[Constant.orderTypeMain]="DineIn";
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => dine_in(tableGroupModelList)));
          }

        else if (GlobalDala.cartPayNowDataList[Constant.orderTypeMain] == "BarTab") {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BarTabScreen()));
        }
        else
          {

            Navigator.of(context).pop(true);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => home("orderType")));
          }

      } else {

        showSnackBarInDialog(context, "Unable to fetch client details. try again.!");

      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle error here
    } finally {
      setState(() {
        _isLoading2 = false; // Set loading state to false after data retrieval
      });
    }
  }
  late List<TableGroupModel> tableGroupModelList;
  Future<void> getTableGroup() async {
     setState(() {
       _isLoading2 = true; // Set loading state to true before fetching data
    });

    try {
      tableGroupModelList = await HomeRepository().getTableGroup();

      if(tableGroupModelList.isNotEmpty)
        {
          getClientDetails();
        }
      else
        {
          showSnackBarInDialog(context, "Unable to fetch data. try again.!");


        }
/*
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => home()));*/
        }
        catch (error) {
      print('Error fetching data: $error');
      // Handle error here
    } finally {
      setState(() {
        _isLoading2 = false; // Set loading state to false after data retrieval
      });
    }
  }

  Future<void> getOrderType() async {

    GlobalDala.orderTypeArray.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();


        setState(() {
          _isLoading = true; // Set loading state to true before fetching data
        });

        try {
          final result = await UserRepository().getOrderType();
          print("result : $result");

          if (result is Map<String, dynamic> && result.containsKey('error')) {
            showSnackBarInDialog(context, '${result['error']}');
          }
          else if (result is HomeModel)
          {
            GlobalDala.homeModel = result;

            // setup if admin
            if(prefs.getInt("isAdmin")==1 || prefs.getInt("isDriver")==0) {

              if (GlobalDala.homeModel?.settings?.olTableTakeOut == "1") {
                GlobalDala.orderTypeArray.add("PICKUP");
              }
              if (GlobalDala.homeModel?.settings?.olTableDelivery == "1") {
                GlobalDala.orderTypeArray.add("Delivery");
              }

              if (GlobalDala.homeModel?.settings?.olTableDineIn == "1") {
                GlobalDala.orderTypeArray.add("DineIn");
              }

              if (GlobalDala.homeModel?.settings?.oLTableBarTab == "1") {
                GlobalDala.orderTypeArray.add("BarTab");
              }

              if (GlobalDala.homeModel?.settings?.olTableDriveThru == "1") {
                GlobalDala.orderTypeArray.add("DriveThru");
              }
              if (GlobalDala.homeModel?.settings?.olTableTOGO == "1") {
                GlobalDala.orderTypeArray.add("TO GO");
              }
              if (GlobalDala.homeModel?.settings?.olTableToStay == "1") {
                GlobalDala.orderTypeArray.add("TO STAY");
              }

              GlobalDala.orderTypeArray.add("RECALL");

            }



          }

          else if (result is String)
          {
            showSnackBarInDialog(context, '${result}');

          }
          else {
            showSnackBarInDialog(context, "Unable to fetch order type. try again.!");


          }



        } catch (error) {
          print('Error fetching data: $error');
          // Handle error here
        } finally {
          setState(() {
            _isLoading = false; // Set loading state to false after data retrieval
          });
        }


    _checkDeliveryRecall();


  }
  Future<void> _checkDeliveryRecall() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if(prefs.getInt("isDriver") == 1)
        {
          GlobalDala.orderTypeArray.add("Recall Delivery");
        }
    });
  }
/*
  UserDetailsModel? userdetail;
  Future<void> _checkStaffBankStatus() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    userdetail = await UserRepository().getloginAccess(codeAccess: prefs.getString('accessCode'));
  }
*/


}
