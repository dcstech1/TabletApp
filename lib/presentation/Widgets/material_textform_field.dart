import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MaterialTextformField extends StatefulWidget {
  const MaterialTextformField(
      {super.key,
      required this.labelText,
      this.helperText,
      this.onChanged,
      this.initialValue, this.autoCorrect, this.autoCapitalize});
  final String labelText;
  final String? helperText;
  final String? initialValue;
  final Function(String)? onChanged;
  final bool? autoCorrect;
  final TextCapitalization? autoCapitalize;
  @override
  State<MaterialTextformField> createState() => _MaterialTextformFieldState();
}

class _MaterialTextformFieldState extends State<MaterialTextformField> {
  final FocusNode myFocusNode = FocusNode();
  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: widget.autoCorrect ?? true,
      textCapitalization: widget.autoCapitalize ?? TextCapitalization.none,
      initialValue: widget.initialValue,
      focusNode: myFocusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppColors.fieldBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
              color: AppColors.fieldBorderColor), // specify color here
        ),
        labelStyle: TextStyle(
            color: myFocusNode.hasFocus
                ? Theme.of(context).primaryColor
                : AppColors.fieldBorderColor),
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        helperText: widget.helperText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        isDense: true,
      ),
      onChanged: widget.onChanged,
    );
  }
}
