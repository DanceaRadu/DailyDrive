import 'package:daily_drive/styling_variables.dart';
import 'package:flutter/material.dart';
import '../../color_palette.dart';

class AuthFormField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const AuthFormField({
    super.key,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: ColorPalette.textColor),
        labelStyle: const TextStyle(
          color: ColorPalette.textColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
          borderSide: const BorderSide(
            color: Color.fromRGBO(130, 130, 130, 1.0),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
          borderSide: const BorderSide(
            color: ColorPalette.accentColor,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(color: ColorPalette.textColor),
    );
  }
}
