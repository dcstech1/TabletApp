import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/core/network/network_manager.dart';
import 'package:tabletapp/core/theme/app_colors.dart';
import 'package:tabletapp/core/theme/app_text_styles.dart';
import 'package:tabletapp/presentation/Widgets/material_button_without_icon.dart';
import 'package:tabletapp/presentation/Widgets/material_textform_field.dart';
import 'package:tabletapp/presentation/screens/order_type/order_type.dart';

import '../../../core/network/services.dart';
import '../../../core/sharedPrefrences/shared_preference.dart';
import '../../../data/Repository/UserRepository.dart';
import '../../../data/models/user_details_model.dart';
import '../../Widgets/custom_toast.dart';
import '../../Widgets/dialog_helper.dart';
import '../global.dart';

class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<login> {
  UserDetailsModel? userdetail;
  TextEditingController accessCodeController = TextEditingController();
  TextEditingController baseUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBaseUrl();

  }

  Future<void> getBaseUrl()
  async {
    GlobalDala.baseUrl = await SharedPreferencesHelper.getBaseUrl() ?? '';
    baseUrlController.text=GlobalDala.baseUrl;
  }

  @override
  void dispose() {
    super.dispose();
    //  changes
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String accessCode = '';

    return Scaffold(
      appBar: AppBar(

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.private_connectivity,size: 40),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'E.g.: https://abc.ca/test/api',
                            ),
                            TextField(
                              controller: baseUrlController,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                labelText: 'Enter your base url here',
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    if (baseUrlController.text.isNotEmpty) {
                                      try {

                                        GlobalDala.baseUrl = baseUrlController.text;
                                        dynamic response = await NetworkManager().request(ApiServices.testConnection);

                                        if(response != null)
                                          {

                                            if (response.toString() == "Connection Successful.") {
                                              await SharedPreferencesHelper.saveBaseUrl(GlobalDala.baseUrl);

                                              showSnackBarInDialogClose(context, "Response\n$response", () {
                                                // This function is called when the dialog is closed
                                                Navigator.of(context).pop(); // Close the main dialog
                                              });
                                            }
                                            else
                                            {
                                              GlobalDala.baseUrl = "";
                                              await SharedPreferencesHelper.saveBaseUrl(GlobalDala.baseUrl);
                                              showSnackBarInDialog(
                                                  context, "Response: \n $response");
                                            }

                                          }



                                      } catch (e) {

                                        GlobalDala.baseUrl = "";
                                        await SharedPreferencesHelper.saveBaseUrl(GlobalDala.baseUrl);

                                        showSnackBarInDialogClose(context, "An error occurred. $e", () {
                                          // This function is called when the dialog is closed
                                          // Close the main dialog
                                        });
                                      }
                                    } else {
                                      showSnackBarInDialog(
                                          context, "Enter base url.");
                                    }
                                  },
                                  child: Text('Connect'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    'Login',
                    style: AppTextStyles.boldBigGreen,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Enter access code'),
                    keyboardType: TextInputType.number,
                    controller: accessCodeController,
                    onChanged: (value) {
                      accessCode = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  MaterialButtonWithoutIcon(
                    title: 'Login',
                    onButtonPressed: () async {
                      setState(() {
                        isLoading =
                            true; // Set isLoading to true when fetching data starts
                      });

                      try {
                        bool result =
                            await InternetConnectionChecker().hasConnection;

                        if (result == true) {
                          print('Login accessCode : ${accessCode}');

                          if (accessCode.isNotEmpty) {



                            userdetail = await UserRepository().getloginAccess(codeAccess: accessCode);

                            if (userdetail != null) {

                              if(userdetail?.isStaffBankEnabled==1 && userdetail?.staffBankStatus == "CLOSE")
                                {
                                  showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {
                                    accessCodeController.clear();
                                  return;
                                  });
                                }
                              else
                                {
                                  SharedPreferencesHelper.saveUserData(userdetail!);
                                  await Future.delayed(Duration(milliseconds: 200));

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('accessCode', accessCode.toString());



                                  List<String>? cartDataList = [];
                                  prefs.setStringList('cartDataList', cartDataList);
                                  GlobalDala.itemCount = cartDataList.length;
                                  accessCodeController.clear();
                                  Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                      builder: (context) => order_type(),
                                    ),
                                  );
                                }

                            } else {
                              showSnackBarInDialog(context,
                                  "Invalid access code. Please enter a valid one.");

                            }
                          } else {
                            showSnackBarInDialog(
                                context, "Please enter accesscode");
                          }
                        } else {
                          showSnackBarInDialog(
                              context, "No internet connection.");
                        }
                      } catch (e) {
                        accessCodeController.clear();
                        print('Login error : ${e.toString()}');


                        if(GlobalDala.baseUrl.isEmpty)
                        {
                          showSnackBarInDialog(context,
                              "Please set your connection first , click on top icon");
                        }
                        else
                          {

                            showSnackBarInDialog(context,
                                "An error occurred. Please try again later.");
                          }
                      } finally {
                        setState(() {
                          isLoading =
                              false; // Set isLoading to false when fetching data completes
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            isLoading
                ? Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.appColor),
                    ),
                  )
                : const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}
