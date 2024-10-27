import 'package:flutter/material.dart';
import '../../color_palette.dart';

class LoginFormField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const LoginFormField({
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
          borderRadius: BorderRadius.circular(14.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(130, 130, 130, 1.0),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
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
