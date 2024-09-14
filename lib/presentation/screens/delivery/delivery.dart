import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../data/models/clientdetail_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../../Widgets/material_button_without_icon.dart';
import '../../Widgets/material_textform_field.dart';
import '../global.dart';
import '../home/home.dart';

import 'package:http/http.dart' as http;
/*
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';*/

class DeliveryForm extends StatefulWidget {
  State<StatefulWidget> createState() => _deliveryState();
}

class _deliveryState extends State<DeliveryForm> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String phoneNo = "";

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

  TextEditingController phoneNoController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController suitNoController = TextEditingController();
  TextEditingController buzzerNoController = TextEditingController();
  TextEditingController roomNoController = TextEditingController();

  //String googleApikey = "AIzaSyBVNKPywiKIxMm9pXEu9MI6_FYThIyUpbg";
  String googleApikey = "AIzaSyCK9A_vtdFo57U-e_tlfX5B35drxjIlGo8";
  TextEditingController _controller = TextEditingController();
  List<dynamic> _suggestions = [];

  void _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApikey';

    final response = await http.get(Uri.parse(url));
    print("Address url : ${url}");
    print("Address response : ${response}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Address data : ${data}");
      print("Address suggestion : ${data['predictions']}");
      setState(() {
        _suggestions = data['predictions'];
      });

      print('_suggestions : $_suggestions');
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  bool isLoading = false;

  List<String> clientNumbers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Delivery"),
          centerTitle: true,
          backgroundColor: AppColors.appColor,
          foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                      child: Column(
                        children: [
                          // Your existing form fields and widgets...
                          // ...
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
                                  borderSide: const BorderSide(
                                      color: AppColors.appColor),
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
                              suitNoController.text = "";
                              buzzerNoController.text = "";
                              roomNoController.text = "";
                              _controller.text = "";
                            });
                          }
                        },),

                     /*   if (isLoading) CircularProgressIndicator(),*/

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
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: suitNoController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: AppColors.appColor),
                              ),
                              labelText: 'Suit No ',
                            ),
                          ),

                          const SizedBox(height: 10),
                          TextFormField(
                            controller: buzzerNoController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: AppColors.appColor),
                              ),
                              labelText: 'Buzzer No',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: roomNoController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: AppColors.appColor),
                              ),
                              labelText: 'Room No ',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _controller,
                            onChanged: _fetchSuggestions,
                            decoration: InputDecoration(
                              hintText: 'Search Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),
                          if (_suggestions.length > 0
)
                            Container(
                              height: 150,
                              // Set a fixed height for the list container
                              child: ListView.builder(
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        _suggestions[index]['description']),
                                    onTap: () {
                                      _controller.text =
                                          _suggestions[index]['description'];
                                      setState(() {
                                        _suggestions = [];
                                      });
                                    },
                                  );
                                },
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
                        ],
                      ),
                    ),
                  ],
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
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            // You can change the color to match your design
            child: MaterialButtonWithoutIcon(
              title: 'Continue',
              onButtonPressed: () async {
                if (phoneNoController.text.isEmpty || phoneNoController.text.length < 10) {
                  showSnackBarInDialog(
                      context, "Please enter valid phone number!");
                  return;
                } else if (firstNameController.text.isEmpty) {
                  showSnackBarInDialog(context, "Please enter first name!");
                  return;
                } else if (_controller.text.isEmpty) {
                  showSnackBarInDialog(context, "Please enter address!");
                  return;
                }
                else {
                  setState(() {
                    isLoading =
                        true; // Set isLoading to true when fetching data starts
                  });
                  try {
                    GlobalDala.clientDetailModel = await HomeRepository()
                        .getPickupClientDetailsFromPhoneNo(phoneNo: phoneNoController.text);

                    if (GlobalDala.clientDetailModel == null) {
                      Map<String, dynamic> jsonData = {
                        "id": 0,
                        "clientId": 0,
                        "orderType": "Delivery",
                        "suitNo": suitNoController.text,
                        "buzzerNo": buzzerNoController.text,
                        "roomNo": roomNoController.text,
                        "firstName": firstNameController.text,
                        "lastName": lastNameController.text,
                        "phoneNo": phoneNoController.text,
                        "address": _controller.text,
                        "orderDesc":
                            "Delivery  Customer Name:${firstNameController.text}",
                        "date": selectedDate.toUtc().toIso8601String(),
                        "time": timeOfDayToString(selectedTime)

                        /* "date": DateFormat('dd-MM-yyyy')
                                                      .format(selectedDate.toLocal()),

                                                  "time": timeOfDayToString(selectedTime),*/
                      };

                      GlobalDala.clientDetailModel = await HomeRepository()
                          .getPickupClientDetailsFromJsonData(
                        body: jsonData,
                      );
                    } else {
                      Map<String, dynamic> jsonData = {
                        "id": 0,
                        "clientId": GlobalDala.clientDetailModel?.clientId,
                        "orderType": "Delivery",
                        "suitNo": GlobalDala.clientDetailModel?.suitNo,
                        "buzzerNo": GlobalDala.clientDetailModel?.buzzerNo,
                        "roomNo": GlobalDala.clientDetailModel?.roomNo,
                        "firstName": GlobalDala.clientDetailModel?.firstName,
                        "lastName": GlobalDala.clientDetailModel?.lastName,
                        "phoneNo": GlobalDala.clientDetailModel?.phoneNo,
                        "address": GlobalDala.clientDetailModel?.address,
                        "orderDesc":
                            "PICKUP   Customer Name: ${GlobalDala.clientDetailModel?.firstName}",
                        "date": selectedDate.toUtc().toIso8601String(),
                        "time": timeOfDayToString(selectedTime)
                      };

                      GlobalDala.clientDetailModel = await HomeRepository()
                          .getPickupClientDetailsFromJsonDataWithClientId(
                              body: jsonData,
                              clientId: GlobalDala.clientDetailModel?.clientId
                                  .toString());
                    }

                    if (GlobalDala.clientDetailModel != null) {
                      GlobalDala.cartPayNowDataList[Constant.clientIdMain] =
                          GlobalDala.clientDetailModel?.clientId;
                      GlobalDala.cartPayNowDataList[Constant.clientNameMain] =
                          GlobalDala.clientDetailModel?.firstName;
                      GlobalDala.cartPayNowDataList[Constant.phoneNumberMain] =
                          GlobalDala.clientDetailModel?.phoneNo;
                      GlobalDala.cartPayNowDataList[Constant.tableInfoMain] =
                          "${GlobalDala.cartPayNowDataList[Constant.orderTypeMain]}  Customer Name:${GlobalDala.cartPayNowDataList[Constant.clientNameMain]}";

                      GlobalDala.cartPayNowDataList[Constant.onDateMain] =
                          DateFormat('dd/MM/yyyy')
                              .format(selectedDate.toLocal());
                      GlobalDala.cartPayNowDataList[Constant.onTimeMain] =
                          timeOfDayToStringForSave(selectedTime);

                      if (GlobalDala.homeModel?.applydeliverychargesaskm == 1) {
                        final data = await HomeRepository()
                            .getDeliveryCharges(_controller.text.toString());
                        if (data != null && data.isNotEmpty) {
                          GlobalDala.cartPayNowDataList[
                              Constant.deliveryChargeMain] = data['charges'];
                        }
                      }
                      else

                        {
                          GlobalDala.cartPayNowDataList[Constant.deliveryChargeMain] =
                              GlobalDala.homeModel?.deliveryCharge;
                        }

                      if (!GlobalDala.isOrderTypeEdit) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => home("Delivery")));
                      } else {
                        Navigator.pop(context, "Task completed!");
                      }
                    } else {
                      showSnackBarInDialog(context,
                          "Unable to fetch client details. try again.!");
                    }
                  } catch (e) {
                    showSnackBarInDialog(
                        context, "An error occurred. Please try again later.");
                  } finally {
                    setState(() {
                      isLoading =
                          false; // Set isLoading to false when fetching data completes
                    });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
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
        suitNoController.text = GlobalDala.clientDetailModel?.suitNo ?? "";
        buzzerNoController.text = GlobalDala.clientDetailModel?.buzzerNo ?? "";
        roomNoController.text = GlobalDala.clientDetailModel?.roomNo ?? "";
        _controller.text = GlobalDala.clientDetailModel?.address ?? "";
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
}
