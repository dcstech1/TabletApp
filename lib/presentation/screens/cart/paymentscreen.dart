import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../data/Repository/UserRepository.dart';
import '../../../data/models/user_details_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../global.dart';
import 'cart.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  PaymentScreen(this.totalAmount);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late TextEditingController totalPayableController;
  late TextEditingController balanceController;
  late TextEditingController changeController;
  final TextEditingController cashController =
      TextEditingController(text: '0.00');
  final TextEditingController debitController =
      TextEditingController(text: '0.00');
  final TextEditingController visaController =
      TextEditingController(text: '0.00');
  final TextEditingController masterController =
      TextEditingController(text: '0.00');
  final TextEditingController amexController =
      TextEditingController(text: '0.00');
  final TextEditingController onAccountController =
      TextEditingController(text: '0.00');
  final TextEditingController otherController =
      TextEditingController(text: '0.00');
  final TextEditingController chequeController =
      TextEditingController(text: '0.00');
  final TextEditingController chequeNoController =
      TextEditingController(text: '000000');
  final TextEditingController giftCardController =
      TextEditingController(text: '0.00');
  final TextEditingController tipAmountController =
      TextEditingController(text: '0.00');


  @override
  void initState() {
    super.initState();
    _checkStaffBankStatus();
    totalPayableController =
        TextEditingController(text: widget.totalAmount.toStringAsFixed(2));
    balanceController =
        TextEditingController(text: widget.totalAmount.toStringAsFixed(2));
    changeController = TextEditingController(text: '0.00');

    totalPayable = double.tryParse(widget.totalAmount.toStringAsFixed(2))!;
    balance = double.tryParse(widget.totalAmount.toStringAsFixed(2))!;
  }

  bool isBT = false;
  bool isOpenTip = false;

  void getTotalPayment() {
    double cash = double.tryParse(cashController.text) ?? 0.0;
    double debit = double.tryParse(debitController.text) ?? 0.0;
    double visa = double.tryParse(visaController.text) ?? 0.0;
    double master = double.tryParse(masterController.text) ?? 0.0;
    double amex = double.tryParse(amexController.text) ?? 0.0;
    double onAccount = double.tryParse(onAccountController.text) ?? 0.0;
    double other = double.tryParse(otherController.text) ?? 0.0;
    double cheque = double.tryParse(chequeController.text) ?? 0.0;
    double giftCard = double.tryParse(giftCardController.text) ?? 0.0;
    totalPayments = cash +
        debit +
        visa +
        master +
        amex +
        onAccount +
        other +
        cheque +
        giftCard;
  }

  void _otherAMountOptionManage(BuildContext context, double enteredAmount) {
    isBT = true;
    // double totalPayable = widget.totalAmount;

    getTotalPayment();
    totalPayments += enteredAmount;
    //balance = ;
    tip = 0.0;
    change = 0.0;
    if((totalPayable - totalPayments) == 0)
      {
        change = 0.0;
        balance = 0.0;

        isOpenTip = false;
        balanceController.text = balance.toStringAsFixed(2);
        changeController.text = change.toStringAsFixed(2);
        Navigator.of(context).pop();
      }
    else if ((totalPayable - totalPayments) < 0) {
      if (GlobalDala.homeModel?.extraAmtAsTip == 1) {
        tip = -(totalPayable - totalPayments);

        if (GlobalDala.homeModel?.dontAllowOverExtraTip ==1 && tip > GlobalDala.homeModel?.overExtraTip) {
          isBT = false;
          showSnackBarInDialogClose(context,
              "${GlobalDala.homeModel?.overExtraTip} tip allowed only!", () {
            //Navigator.of(context).pop();
          });
        } else {

          isOpenTip = false;
          balance = 0.0;
          tipAmountController.text = tip.toStringAsFixed(2);
          balanceController.text = balance.toStringAsFixed(2);
          Navigator.of(context).pop();
        }
      } else {
        change = -(totalPayable - totalPayments);
        balance = 0.0;

        isOpenTip = false;
        balanceController.text = balance.toStringAsFixed(2);
        changeController.text = change.toStringAsFixed(2);
        Navigator.of(context).pop();
      }
    } else {
      balance = totalPayable - totalPayments;
      balanceController.text = balance.toStringAsFixed(2);
      Navigator.of(context).pop();
    }
  }

  void _resetFields() {
    totalPayableController.text = widget.totalAmount.toStringAsFixed(2);
    balanceController.text = widget.totalAmount.toStringAsFixed(2);
    changeController.text = '0.00';
    cashController.text = '0.00';
    debitController.text = '0.00';
    visaController.text = '0.00';
    masterController.text = '0.00';
    amexController.text = '0.00';
    onAccountController.text = '0.00';
    otherController.text = '0.00';
    chequeController.text = '0.00';
    chequeNoController.text = '000000';
    giftCardController.text = '0.00';
    tipAmountController.text = '0.00';
    totalPayable = double.tryParse(widget.totalAmount.toStringAsFixed(2))!;
    balance = double.tryParse(widget.totalAmount.toStringAsFixed(2))!;
    cash = 0.0;
    change = 0.0;
    totalPayments = 0.0;
    tip = 0.0;
    isOpenTip = false;
    setState(() {});
  }

  double totalPayable = 0.0;
  double cash = 0.0;
  double balance = 0.0;
  double change = 0.0;
  double totalPayments = 0.0;
  double tip = 0.0;

  void _cashAmountManage(BuildContext context, double enteredAmount) {
    cash = enteredAmount ?? 0.0;
    isBT = true;
    getTotalPayment();
    totalPayments += cash;
    change = 0.0;
    totalPayable=_roundToNearestFiveCents(totalPayable);
    totalPayableController.text = totalPayable.toStringAsFixed(2);

    if ((  _roundToNearestFiveCents(totalPayable) - totalPayments) == 0) {
      balance = 0.0;
      balanceController.text = balance.toStringAsFixed(2);
      changeController.text = change.toStringAsFixed(2);
      isOpenTip = true;
      Navigator.of(context).pop();
    }
    else if ((  _roundToNearestFiveCents(totalPayable) - totalPayments) < 0) {
      change = -(_roundToNearestFiveCents(totalPayable) - totalPayments);


      if(GlobalDala.homeModel?.extraAmtAsTip == 1 && GlobalDala.homeModel?.promptExtraCashAsTip == 1 &&  change > 0)
      {

        isBT = false;
        _showTipDialog(change, enteredAmount);
      /*  if ( GlobalDala.homeModel?.promptExtraCashAsTip == 1)
        {
          isBT = false;
          _showTipDialog(change, enteredAmount);
        }
        else
        {
          tipAmountController.text =
              (double.parse(tipAmountController.text) + change)
                  .toStringAsFixed(2);
          balance = 0.0;
          balanceController.text = balance.toStringAsFixed(2);
          cashController.text =
              (double.parse(cashController.text) + enteredAmount)
                  .toStringAsFixed(2);
        }*/

      }
      else
      {
        balance = 0.0;
        balanceController.text = balance.toStringAsFixed(2);
        changeController.text = change.toStringAsFixed(2);
        isOpenTip = true;
        Navigator.of(context).pop();

        if(GlobalDala.homeModel?.cashTipOption == 0)
          {
            sendPayment();
          }
      }

      /* if (GlobalDala.homeModel?.cashTipOption == 0 &&
            GlobalDala.homeModel?.promptExtraCashAsTip == 0 &&
            change > 0) {
          isBT = false;
          _showTipDialog(change, enteredAmount);
        } else {
          balance = 0.0;
          balanceController.text = balance.toStringAsFixed(2);
          changeController.text = change.toStringAsFixed(2);
          Navigator.of(context).pop();
        }*/
    } else {
      balance = _roundToNearestFiveCents(totalPayable) - totalPayments;
      balanceController.text = balance.toStringAsFixed(2);
      Navigator.of(context).pop();
    }

    /*
    if (totalPayments > 0 &&
        double.parse(cashController.text) != totalPayments) {
      totalPayments += cash;

      if ((totalPayable - totalPayments) < 0) {
        if (GlobalDala.homeModel?.extraAmtAsTip == 1) {
          tip = -(totalPayable - totalPayments);
          if (tip > GlobalDala.homeModel?.overExtraTip) {
            isBT = false;
            showSnackBarInDialogClose(context,
                "${GlobalDala.homeModel?.overExtraTip} tip allowed only!", () {
              //Navigator.of(context).pop();
            });
          } else {
            balance = 0.0;
            tipAmountController.text = tip.toStringAsFixed(2);
            balanceController.text = balance.toStringAsFixed(2);
            Navigator.of(context).pop();
          }
        } else {
          change = -(totalPayable - totalPayments);
          balance = 0.0;
          balanceController.text = balance.toStringAsFixed(2);
          changeController.text = change.toStringAsFixed(2);
          Navigator.of(context).pop();
        }
      } else {
        balance = totalPayable - totalPayments;
        balanceController.text = balance.toStringAsFixed(2);
        Navigator.of(context).pop();
      }
    }
    else {
      totalPayments += cash;
      change = 0.0;
      if ((totalPayable - totalPayments) < 0) {
        change = -(totalPayable - totalPayments);


        if(GlobalDala.homeModel?.cashTipOption == 1 &&  change > 0)
          {
            if ( GlobalDala.homeModel?.promptExtraCashAsTip == 1)
              {
                isBT = false;
                _showTipDialog(change, enteredAmount);
              }
            else
              {
                tipAmountController.text =
                    (double.parse(tipAmountController.text) + change)
                        .toStringAsFixed(2);
                balance = 0.0;
                balanceController.text = balance.toStringAsFixed(2);
                cashController.text =
                    (double.parse(cashController.text) + enteredAmount)
                        .toStringAsFixed(2);
              }

          }
        else
          {
            balance = 0.0;
            balanceController.text = balance.toStringAsFixed(2);
            changeController.text = change.toStringAsFixed(2);
            Navigator.of(context).pop();
          }


       */
    /* if (GlobalDala.homeModel?.cashTipOption == 0 &&
            GlobalDala.homeModel?.promptExtraCashAsTip == 0 &&
            change > 0) {
          isBT = false;
          _showTipDialog(change, enteredAmount);
        } else {
          balance = 0.0;
          balanceController.text = balance.toStringAsFixed(2);
          changeController.text = change.toStringAsFixed(2);
          Navigator.of(context).pop();
        }*/
    /*
      } else {
        balance = totalPayable - totalPayments;
        balanceController.text = balance.toStringAsFixed(2);
        Navigator.of(context).pop();
      }
    }
*/
  }

  void _showTipDialog(double changeAmount, double enterAmount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Extra Cash'),
          content: Text('Do you want to add extra cash amount as a tip?'),
          actions: [
            TextButton(
              onPressed: () {
                if (GlobalDala.homeModel?.dontAllowOverExtraTip ==1 && changeAmount > GlobalDala.homeModel?.overExtraTip) {
                  showSnackBarInDialogClose(context,
                      "${GlobalDala.homeModel?.overExtraTip} tip allowed only!",
                      () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                  });
                } else {
                  isOpenTip = true;
                  tipAmountController.text =
                      (double.parse(tipAmountController.text) + changeAmount)
                          .toStringAsFixed(2);
                  balance = 0.0;
                  balanceController.text = balance.toStringAsFixed(2);
                  cashController.text =
                      (double.parse(cashController.text) + enterAmount)
                          .toStringAsFixed(2);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  if(GlobalDala.homeModel?.cashTipOption == 0)
                  {
                    sendPayment();
                  }
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                balance = 0.0;
                isOpenTip = true;
                balanceController.text = balance.toStringAsFixed(2);
                changeController.text =
                    (double.parse(changeController.text) + changeAmount)
                        .toStringAsFixed(2);
                cashController.text =
                    (double.parse(cashController.text) + enterAmount)
                        .toStringAsFixed(2);

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                if(GlobalDala.homeModel?.cashTipOption == 0)
                {
                  sendPayment();
                }
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }


  Future<void> sendPayment()
  async {

    if(userdetail?.isStaffBankEnabled == 1 && userdetail?.staffBankStatus == "CLOSE")
    {
      showSnackBarInDialogClose(context, "Staff bank not open for this user.", () {

        return;
      });
    }
    else
    {
      print("Send payment success");
      setState(() {
        isLoading =
        true; // Set isLoading to true when fetching data starts
      });
      try {
        double chequeAmount =
            double.tryParse(chequeController.text) ?? 0.0;
        String chequeNo = chequeNoController.text.trim();

        if (chequeAmount > 0 && (chequeNo.isEmpty || double.tryParse(chequeNoController.text)! <= 0)) {
          showSnackBarInDialog(
              context, "Please enter cheque number.");
          return;
        }
        if (balance == 0) {

          final Map<String, dynamic> requestData = {
            "orderId":
            GlobalDala.cartPayNowDataList[Constant.idMain],
            "driverId": GlobalDala.cartPayNowDataList[Constant.userIdMain],
            "cash": cashController.text,
            "debit": debitController.text,
            "visa": visaController.text,
            "master": masterController.text,
            "amex": amexController.text,
            "other": otherController.text,
            "onAccount": onAccountController.text,
            "cheque": chequeController.text,
            "chequeNo": chequeNoController.text,
            "change": changeController.text,
            "tip": tipAmountController.text,
            "payment": double.tryParse(totalPayable.toStringAsFixed(2))
          };

          print("payment data $requestData");
          final result = await HomeRepository()
              .postPayment(body: requestData);

          if (result != null) {
            if (result is Map<String, dynamic> &&
                result.containsKey('error')) {
              showSnackBarInDialog(context, '${result['error']}');
            } else if (result['statusCode'] == '0000') {
              showSnackBarInDialogClose(
                  context, '${result['statusMessage']}',
                      () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                    List<String>? cartDataList = [];
                    prefs.setStringList('cartDataList', cartDataList);
                    GlobalDala.itemCount = cartDataList.length;
                    if (Navigator.canPop(context)) {
                      Navigator.popUntil(
                          context, (route) => route.isFirst);
                      Navigator.pushNamed(context, "/orderType");
                    } else {
                      SystemNavigator.pop();
                    }
                  });
            } else {
              showSnackBarInDialog(context,
                  "Unable to send payment. Please try again.");
            }
          } else {
            showSnackBarInDialog(context,
                "Unable to send payment. Please try again.");
          }
        }


      } catch (e) {
        print(e);
        showSnackBarInDialog(context,
            "Unable to send payment. Please try again.");
      } finally {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching data completes
        });
      }
    }



  }
  @override
  void dispose() {
    totalPayableController.dispose();
    balanceController.dispose();
    changeController.dispose();
    cashController.dispose();
    debitController.dispose();
    visaController.dispose();
    masterController.dispose();
    amexController.dispose();
    onAccountController.dispose();
    otherController.dispose();
    chequeController.dispose();
    chequeNoController.dispose();
    giftCardController.dispose();
    tipAmountController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:() async {

      Navigator.of(context).pop(true);
          return true;
        },
        child: Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildSummaryColumn('Total Payable', totalPayableController),
                _buildSummaryColumn('Balance', balanceController),
                _buildSummaryColumn('Change', changeController),
              ],
            ),
          ),
         /* Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  _buildPaymentRow('CASH', cashController),
                  _buildPaymentRow('VISA', visaController),
                  _buildPaymentRow('DEBIT', debitController),
                  _buildPaymentRow('MASTER', masterController),
                  _buildPaymentRow('AMEX', amexController),
                  _buildPaymentRow('CHEQUE', chequeController),
                  _buildPaymentRow('CHEQUE NO', chequeNoController, isEnable: true),
                  _buildPaymentRow('ON ACCOUNT', onAccountController),
                  _buildPaymentRow('GIFT CARD', giftCardController),
                  _buildPaymentRow('OTHER', otherController),
                  _buildPaymentRow('TIP AMOUNT', tipAmountController),
                ],
              ),
            ),
          ),*/

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: GlobalDala.homeModel?.paymodes
                    ?.where((paymode) => paymode['disable'] == 0) // Only show if disable == 0
                    .map<Widget>((paymode) {
                  String displayName = (paymode['changeName']?.isNotEmpty ?? false)
                      ? paymode['changeName']
                      : paymode['name'];
                  TextEditingController controller;

                  // Assign the appropriate controller based on the name
                  switch (paymode['name']) {
                    case 'Cash':
                      controller = cashController;
                      break;
                    case 'Visa':
                      controller = visaController;
                      break;
                    case 'Debit':
                      controller = debitController;
                      break;
                    case 'Master':
                      controller = masterController;
                      break;
                    case 'Amex':
                      controller = amexController;
                      break;
                    case 'Cheque':
                      controller = chequeController;
                      break;
                    case 'OnAccount':
                      controller = onAccountController;
                      break;
                    case 'GiftCard':
                      controller = giftCardController;
                      break;
                    case 'Other':
                      controller = otherController;
                      break;
                    case 'Tip':
                      controller = tipAmountController;
                      break;
                    default:
                      controller = TextEditingController(); // Fallback if not found
                  }

                  // Conditionally show 'Cheque No' field if cheque is enabled
                  if (paymode['name'] == 'Cheque') {
                    return Column(
                      children: [
                        _buildPaymentRow(displayName, controller),
                        _buildPaymentRow('Cheque No', chequeNoController, isEnable: true),
                      ],
                    );
                  }

                  // Build payment row for all other paymodes
                  return _buildPaymentRow(displayName, controller);
                }).toList() ??
                    [], // Handle null paymodes
              ),
            ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _resetFields,
                    child: Text('   Reset   ',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.appColor),
                    ),
                  ),
                  SizedBox(width: 16),
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

                        setState(() {
                          isLoading =
                          true; // Set isLoading to true when fetching data starts
                        });
                        try {
                          if (balance != 0) {
                            showSnackBarInDialog(
                                context, "Please complete the payment");
                            return;
                          }

                          double chequeAmount =
                              double.tryParse(chequeController.text) ?? 0.0;
                          String chequeNo = chequeNoController.text.trim();

                          if (chequeAmount > 0 &&
                              (chequeNo.isEmpty ||
                                  double.tryParse(chequeNoController.text)! <=
                                      0)) {
                            showSnackBarInDialog(
                                context, "Please enter cheque number.");
                            return;
                          }
                          final Map<String, dynamic> requestData = {
                            "orderId":
                            GlobalDala.cartPayNowDataList[Constant.idMain],
                            "driverId": GlobalDala.cartPayNowDataList[Constant.userIdMain],
                            "cash": cashController.text,
                            "debit": debitController.text,
                            "visa": visaController.text,
                            "master": masterController.text,
                            "amex": amexController.text,
                            "other": otherController.text,
                            "onAccount": onAccountController.text,
                            "cheque": chequeController.text,
                            "chequeNo": chequeNoController.text,
                            "change": changeController.text,
                            "tip": tipAmountController.text,
                            "payment": double.tryParse(totalPayable.toStringAsFixed(2))
                          };

                          print("payment data $requestData");
                          final result = await HomeRepository()
                              .postPayment(body: requestData);

                          if (result != null) {
                            if (result is Map<String, dynamic> &&
                                result.containsKey('error')) {
                              showSnackBarInDialog(context, '${result['error']}');
                            } else if (result['statusCode'] == '0000') {
                              showSnackBarInDialogClose(
                                  context, '${result['statusMessage']}',
                                      () async {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                    List<String>? cartDataList = [];
                                    prefs.setStringList('cartDataList', cartDataList);
                                    GlobalDala.itemCount = cartDataList.length;
                                    if (Navigator.canPop(context)) {
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                      Navigator.pushNamed(context, "/orderType");
                                    } else {
                                      SystemNavigator.pop();
                                    }
                                  });
                            } else {
                              showSnackBarInDialog(context,
                                  "Unable to send payment. Please try again.");
                            }
                          } else {
                            showSnackBarInDialog(context,
                                "Unable to send payment. Please try again.");
                          }
                        } catch (e) {
                          print(e);
                          showSnackBarInDialog(context,
                              "Unable to send payment. Please try again.");
                        } finally {
                          setState(() {
                            isLoading =
                            false; // Set isLoading to false when fetching data completes
                          });
                        }
                      }




                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.appColor),
                    ),
                    child: Text('   Pay   ',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _showAmountInputDialog(String label, TextEditingController controller,{double? initialValue}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
       // String initialText = (initialValue ?? balance).toStringAsFixed(2);
        double value = initialValue ?? balance;

        // Apply rounding logic if the label is 'Cash'
        if (label == 'Cash') {
          value = _roundToNearestFiveCents(value);
        }

        // Convert the rounded value to a string with 2 decimal places
        String initialText = value.toStringAsFixed(2);
        TextEditingController dialogController =
            TextEditingController(text: initialText);
        FocusNode amountFocusNode = FocusNode();
        amountFocusNode.addListener(() {
          if (amountFocusNode.hasFocus) {
            // Select all text when the field gains focus
            dialogController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: dialogController.text.length,
            );
          }
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          amountFocusNode.requestFocus();
        });
        return AlertDialog(
          title: Text('Enter Amount'),
          content: TextFormField(
            controller: dialogController,
            focusNode: amountFocusNode,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                String enteredAmount = dialogController.text;
                if (enteredAmount.isNotEmpty) {
                  if (label == 'Cash') {
                    _cashAmountManage(
                        context, double.parse(enteredAmount));
                    if (isBT) {
                      double amount = double.parse(enteredAmount);
                      controller.text = (double.parse(controller.text) + amount)
                          .toStringAsFixed(2);
                    }
                    if(balance == 0)
                    {
                      sendPayment();
                    }
                  }else if (label == 'Tip') {
                    if ( double.parse(enteredAmount) <=double.parse(change.toStringAsFixed(2))) {
                      if (GlobalDala.homeModel?.dontAllowOverExtraTip ==1 && double.parse(enteredAmount) > GlobalDala.homeModel?.overExtraTip) {

                        showSnackBarInDialogClose(context,
                            "${GlobalDala.homeModel?.overExtraTip} tip allowed only!", () {
                              //Navigator.of(context).pop();
                            });
                      }
                      else
                        {
                          tipAmountController.text =  double.parse(enteredAmount).toStringAsFixed(2);
                          changeController.text = (double.parse(change.toStringAsFixed(2)) -double.parse(enteredAmount)).toStringAsFixed(2);
                          Navigator.of(context).pop();
                        }


                    }
                  } else {
                    _otherAMountOptionManage(context, double.parse(enteredAmount));
                    print("    isBT = $isBT");
                    if (isBT) {
                      double amount = double.parse(enteredAmount);
                      controller.text = (double.parse(controller.text) + amount)
                          .toStringAsFixed(2);
                    }
                    if(balance == 0)
                      {
                        sendPayment();
                      }
                  }
                }
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  double _roundToNearestFiveCents(double value) {
    // Multiply by 20, round, and then divide by 20 to get the nearest 0.05
    return (value * 20).round() / 20.0;
  }
  Widget _buildSummaryColumn(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(label),
          SizedBox(height: 8),
          Container(
            width: 100,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, TextEditingController controller,
      {bool isEnable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          if (isOpenTip && label == 'Tip'  && double.parse(cashController.text) > 0 && GlobalDala.homeModel?.cashTipOption == 1) {
            // Open dialog with tipAmount as initial value
            _showAmountInputDialog(label, controller, initialValue: double.parse(tipAmountController.text));
          }
         else if (balance > 0 && label != 'Cheque No' && label != 'Tip' ) {
            _showAmountInputDialog(label, controller);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Container(
              width: 100,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                enabled: isEnable,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  UserDetailsModel? userdetail;
  Future<void> _checkStaffBankStatus() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    userdetail = await UserRepository().getloginAccess(codeAccess: prefs.getString('accessCode'));
  }


}
