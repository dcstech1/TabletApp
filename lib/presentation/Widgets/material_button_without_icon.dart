import 'package:flutter/material.dart';

class MaterialButtonWithoutIcon extends StatelessWidget {
  const MaterialButtonWithoutIcon(
      {super.key,
      required this.title,
      required this.onButtonPressed,
      this.inListView,
      this.isTilted = false});
  final String title;
  final void Function() onButtonPressed;
  final bool? inListView;
  final bool isTilted;
  @override
  Widget build(BuildContext context) {
    if (inListView == true) {
      return MaterialButton(
        color: Theme.of(context).primaryColor,
        minWidth: 15,
        height: 35,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        onPressed: onButtonPressed,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    return MaterialButton(
      color: isTilted ? Colors.grey.shade300 : Theme.of(context).primaryColor,
      minWidth: double.infinity,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      onPressed: onButtonPressed,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: isTilted ? Colors.black : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
