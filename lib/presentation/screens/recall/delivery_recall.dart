import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../data/Repository/UserRepository.dart';
import '../../../data/models/recall_model.dart';
import '../../../data/models/user_details_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../cart/paymentscreen.dart';
import '../global.dart';

class RecallDelivery extends StatefulWidget {
  @override
  State<RecallDelivery> createState() => _RecallDeliveryState();
}

class _RecallDeliveryState extends State<RecallDelivery> {

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recall Delivery'),
        ),
        body: FutureBuilder<List<RecallModel>>(
            future: HomeRepository().getOrderlistForRecallDelivery(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final recallList = snapshot.data!;

                print('recallList ${recallList.length}');
                if (recallList.isNotEmpty && recallList.length > 0) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('')),
                                DataColumn(label: Text('Order No')),
                                DataColumn(label: Text('Token')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Phone')),
                                DataColumn(label: Text('Address')),
                                DataColumn(label: Text('Driver')),
                                DataColumn(label: Text('Amount')),
                              ],
                              rows: recallList.map((order) {
                                IconData icon = Icons.delivery_dining_rounded;

                                Color iconColor=Colors.black;;
                                VoidCallback onPressedAction = () {};



                                // Set the icon and onPressed action based on the status
                                switch (order.status) {
                                  case 'NOT DELIVERED':
                                    icon = Icons.delivery_dining_rounded;
                                    iconColor = Colors.red;// Example icon for arrival
                                    onPressedAction = () async {

                                      try {
                                        setState(() {
                                          isLoading = true; // Set isLoading to false when fetching data completes
                                        });
                                        final Map<String, dynamic> requestData =
                                        {
                                          "driverId": GlobalDala.cartPayNowDataList[Constant.userIdMain],
                                          "orderId": order.id,
                                          "action": "depart"
                                        };
                                        final result = await HomeRepository()
                                            .postRecallDelivery(
                                            body: requestData);

                                        if (result.containsKey('success')) {
                                          showSnackBarInDialog(
                                              context, "${result['success']}");
                                        } else if (result
                                            .containsKey('error')) {
                                          showSnackBarInDialog(
                                              context, "${result['error']}");
                                        } else {
                                          showSnackBarInDialog(context,
                                              "Unexpected response: $result");
                                        }
                                      } catch (e) {
                                        print(e);
                                        setState(() {
                                          isLoading = false; // Set isLoading to false when fetching data completes
                                        });
                                      }
                                      finally
                                      {
                                        setState(() {
                                          isLoading = false; // Set isLoading to false when fetching data completes
                                        });
                                      }

                                    };
                                    break;
                                  case 'IN-PROGRESS':
                                    icon = Icons.delivery_dining_rounded;
                                    iconColor = Colors.green;// Example icon for departure
                                    onPressedAction = () async {

                                      try {
                                        setState(() {
                                          isLoading = true; // Set isLoading to false when fetching data completes
                                        });
                                        final Map<String, dynamic> requestData =
                                        {
                                          "driverId": GlobalDala.cartPayNowDataList[Constant.userIdMain],
                                          "orderId": order.id,
                                          "action": "arrive"
                                        };
                                        final result = await HomeRepository()
                                            .postRecallDelivery(
                                            body: requestData);

                                        if (result.containsKey('success')) {
                                          showSnackBarInDialog(
                                              context, "${result['success']}");
                                        } else if (result
                                            .containsKey('error')) {
                                          showSnackBarInDialog(
                                              context, "${result['error']}");
                                        } else {
                                          showSnackBarInDialog(context,
                                              "Unexpected response: $result");
                                        }
                                      } catch (e) {
                                        print(e);
                                        setState(() {
                                          isLoading = false; // Set isLoading to false when fetching data completes
                                        });
                                      }
                                      finally
                                      {
                                        setState(() {
                                          isLoading = false; // Set isLoading to false when fetching data completes
                                        });
                                      }


                                    };
                                    break;
                                  case 'DELIVERED':
                                    icon = Icons
                                        .payment;// Example icon for payment
                                    iconColor = Colors.black;
                                    onPressedAction = () {

                                      GlobalDala.cartPayNowDataList[Constant.idMain] = order.id;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen( order.orderTotal ??
                                                      0.00)));
                                    };
                                    break;
                                }

                                return DataRow(cells: [
                                  DataCell(
                                    IconButton(
                                      icon: Icon(icon, color: iconColor),
                                      onPressed: onPressedAction,
                                    ),
                                  ),
                                  DataCell(
                                      Text(order.orderNumber.toString() ?? '')),
                                  DataCell(
                                      Text(order.tokenNumber.toString() ?? '')),
                                  DataCell(
                                      Text(order.status.toString() ?? '')),
                                  DataCell(Text(order.clientName ?? 'N/A')),
                                  DataCell(Text(order.phoneNumber ?? 'N/A')),
                                  DataCell(Text(order.address ?? 'N/A')),
                                  DataCell(Text(order.drivername ?? 'N/A')),
                                  DataCell(Text((order.orderTotal ?? 0.00)
                                      .toStringAsFixed(2))),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
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
                    ],
                  );
                }
                return Center(
                  child: Container(
                    child: Text(
                      "No order found!",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }
            }));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

}
