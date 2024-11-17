import 'package:daily_drive/styling_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../color_palette.dart';

class MainTextField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String? trailingText;
  final bool isNumeric;

  const MainTextField({
    super.key,
    required this.labelText,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.trailingText,
    this.isNumeric = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon == null ? null : Icon(icon, color: ColorPalette.textColor),
        suffixText: trailingText,
        labelStyle: const TextStyle(
          color: ColorPalette.textColor,
          fontSize: 15.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
          borderSide: const BorderSide(
            color: Color.fromRGBO(130, 130, 130, 1.0),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
          borderSide: const BorderSide(
            color: ColorPalette.accent,
            width: 1.0,
          ),
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (isNumeric) FilteringTextInputFormatter.digitsOnly,
      ],
      style: const TextStyle(
        color: ColorPalette.textColor,
        fontSize: 14.0,
      ),
    );
  }
}
