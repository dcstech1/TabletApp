import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tabletapp/core/theme/app_colors.dart';

class CustomToast {
  final String message;
  final int toastLength; // in seconds
  final VoidCallback? onCompletion;

  CustomToast({
    required this.message,
    this.toastLength = 2,
    this.onCompletion,
  });

  void showSuccessToast() {
    showToast(AppColors.successBGColor, AppColors.successTextColor);
  }

  void showErrorToast() {
    showToast(AppColors.errorBGColor, AppColors.errorTextColor);
  }

  void showToast(Color bgColor, Color textColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 16,
    );
    onCompletionAfterDelay();
  }

  void onCompletionAfterDelay() {
    if (onCompletion != null) {
      Future.delayed(Duration(seconds: toastLength), onCompletion);
    }
  }
}
