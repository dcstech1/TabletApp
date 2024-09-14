import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabletapp/data/Repository/HomeModuleRepository.dart';
import 'package:tabletapp/data/models/clientdetail_model.dart';

import '../../../core/network/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../../Widgets/material_button_without_icon.dart';
import '../../Widgets/material_textform_field.dart';
import '../global.dart';
import '../home/home.dart';

class PickUpForm extends StatefulWidget {
  State<StatefulWidget> createState() => _pickupState();
}

class _pickupState extends State<PickUpForm> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String phoneNo = "";

  TextEditingController phoneNoController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String timeOfDayToString(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final formattedTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(dateTime);
    return formattedTime;
  }

  String timeOfDayToStringForSave(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final formattedTime = DateFormat("HH:mm:ss").format(dateTime);
    return formattedTime;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  bool isLoading = false;
  List<String> clientNumbers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Pick Up"),
            centerTitle: true,
            backgroundColor: AppColors.appColor,
            foregroundColor: Colors.white),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Focus(
                      child: TextField(
                        controller: phoneNoController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            phoneNo = value;
                          });
                          if (phoneNo.isNotEmpty) {
                            searchClientDetails(phoneNo);
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.appColor),
                          ),
                          labelText: 'Phone No *',
                        ),
                      ),
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          // do stuff
                          clientNumbers.clear();
                          if (int.tryParse(phoneNoController.text) != null) {
                            fetchClientDetails(phoneNoController.text);
                          }
                        } else {
                          setState(() {
                            firstNameController.text = "";
                            lastNameController.text = "";
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),
                    if (clientNumbers.length > 0)
                      Container(
                        height: 120,
                        // Set a fixed height for the list container
                        child: ListView.builder(
                          itemCount: clientNumbers.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(clientNumbers[index]),
                              onTap: () {
                                setState(() {
                                  phoneNoController.text = clientNumbers[index];
                                  fetchClientDetails(clientNumbers[index]);
                                  setState(() {
                                    clientNumbers.clear();
                                  });
                                });
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.appColor),
                        ),
                        labelText: 'First Name *',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.appColor),
                        ),
                        labelText: 'Last Name *',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Date',
                      ),
                      controller: TextEditingController(
                          text: selectedDate != null
                              ? DateFormat('dd-MM-yyyy')
                                  .format(selectedDate.toLocal())
                              : "Select Date"),
                      onTap: () => _selectDate(context),
                      readOnly: true,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Time',
                      ),
                      controller: TextEditingController(
                          text: selectedTime.format(context)),
                      onTap: () => _selectTime(context),
                      readOnly: true,
                    ),
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
                    const SizedBox(height: 10),
                    MaterialButtonWithoutIcon(
                      title: 'Continue',
                      onButtonPressed: () async {
                        if (phoneNoController.text.isEmpty || phoneNoController.text.length < 10) {
                          showSnackBarInDialog(
                              context, "Please enter valid phone number !");
                        } else if (firstNameController.text.isEmpty) {
                          showSnackBarInDialog(
                              context, "Please enter first name!");
                        } else {
                          setState(() {
                            isLoading =
                                true; // Set isLoading to true when fetching data starts
                          });

                          try {
                            GlobalDala.clientDetailModel =
                                await HomeRepository()
                                    .getPickupClientDetailsFromPhoneNo(
                                        phoneNo: phoneNoController.text);

                            if (GlobalDala.clientDetailModel == null) {
                              Map<String, dynamic> jsonData = {
                                "id": 0,
                                "clientId": 0,
                                "orderType": "PICKUP",
                                "firstName": firstNameController.text,
                                "lastName": lastNameController.text,
                                "phoneNo": phoneNoController.text,
                                "orderDesc":
                                    "PICKUP   Customer Name:${firstNameController.text}",
                                "date": selectedDate.toUtc().toIso8601String(),
                                "time": timeOfDayToString(selectedTime)
                              };

                              log("jsonData Order__ = ${jsonData.toString()}");
                              GlobalDala.clientDetailModel =
                                  await HomeRepository()
                                      .getPickupClientDetailsFromJsonData(
                                body: jsonData,
                              );
                              print(
                                  ' GlobalDala.clientDetailModel2 : ${GlobalDala.clientDetailModel}');
                            } else {
                              Map<String, dynamic> jsonData = {
                                "id": 0,
                                "clientId":
                                    GlobalDala.clientDetailModel?.clientId,
                                "orderType": "PICKUP",
                                "firstName":
                                    GlobalDala.clientDetailModel?.firstName,
                                "lastName":
                                    GlobalDala.clientDetailModel?.lastName,
                                "phoneNo":
                                    GlobalDala.clientDetailModel?.phoneNo,
                                "orderDesc":
                                    "PICKUP   Customer Name: ${GlobalDala.clientDetailModel?.firstName}",
                                "date": selectedDate.toUtc().toIso8601String(),
                                "time": timeOfDayToString(selectedTime)
                              };

                              GlobalDala.clientDetailModel = await HomeRepository()
                                  .getPickupClientDetailsFromJsonDataWithClientId(
                                      body: jsonData,
                                      clientId: GlobalDala
                                          .clientDetailModel?.clientId
                                          .toString());
                            }

                            if (GlobalDala.clientDetailModel != null) {
                              GlobalDala.cartPayNowDataList[
                                      Constant.clientIdMain] =
                                  GlobalDala.clientDetailModel?.clientId;
                              GlobalDala.cartPayNowDataList[
                                      Constant.clientNameMain] =
                                  GlobalDala.clientDetailModel?.firstName;
                              GlobalDala.cartPayNowDataList[
                                      Constant.phoneNumberMain] =
                                  GlobalDala.clientDetailModel?.phoneNo;
                              GlobalDala.cartPayNowDataList[
                                      Constant.tableInfoMain] =
                                  "${GlobalDala.cartPayNowDataList[Constant.orderTypeMain]}  Customer Name:${GlobalDala.cartPayNowDataList[Constant.clientNameMain]}";

                              GlobalDala
                                      .cartPayNowDataList[Constant.onDateMain] =
                                  DateFormat('dd/MM/yyyy')
                                      .format(selectedDate.toLocal());
                              GlobalDala
                                      .cartPayNowDataList[Constant.onTimeMain] =
                                  timeOfDayToStringForSave(selectedTime);

                              if (!GlobalDala.isOrderTypeEdit) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => home("pickUp")));
                              } else {
                                Navigator.pop(context, "Task completed!");
                              }
                            } else {
                              showSnackBarInDialog(context,
                                  "Unable to fetch client details. try again.!");
                            }
                          } catch (e) {
                            print('Login error : ${e.toString()}');
                            showSnackBarInDialog(context,
                                "An error occurred. Please try again later.");
                          } finally {
                            setState(() {
                              isLoading =
                                  false; // Set isLoading to false when fetching data completes
                            });
                          }
                        }
                      },
                    ),
                  ]),
                )
              ],
            ),
          ),
        ));
  }
  Future<void> searchClientDetails(String phoneNumber) async {
    try {
      // Make the API call to fetch client details
      setState(() {
        isLoading = true; // Set isLoading to true when fetching data starts
      });
      List<ClientDetailModel> ClientDetailModeList = await HomeRepository()
          .searchClientDetailsFromPhoneNo(phoneNo: phoneNumber);
      clientNumbers.clear();
      if (ClientDetailModeList.isNotEmpty) {

        for(int i=0; i<ClientDetailModeList.length ; i++)
        {
          clientNumbers.add("${ClientDetailModeList[i].phoneNo}");
        }
        setState(() {

        });
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching client details: $e');
    } finally {
      setState(() {
        isLoading =
        false; // Set isLoading to false when fetching data completes
      });
    }
  }
  Future<void> fetchClientDetails(String phoneNumber) async {
    try {
      // Make the API call to fetch client details
      setState(() {
        isLoading = true; // Set isLoading to true when fetching data starts
      });

      GlobalDala.clientDetailModel = await HomeRepository()
          .getPickupClientDetailsFromPhoneNo(phoneNo: phoneNumber);

      if (GlobalDala.clientDetailModel != null) {
        firstNameController.text =
            GlobalDala.clientDetailModel?.firstName ?? "";
        lastNameController.text = GlobalDala.clientDetailModel?.lastName ?? "";
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching client details: $e');
    } finally {
      setState(() {
        isLoading =
            false; // Set isLoading to false when fetching data completes
      });
    }
  }
}
