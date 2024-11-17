import 'package:flutter/material.dart';
import '../color_palette.dart';
import '../styling_variables.dart';

class MainDropdown extends StatelessWidget {
  const MainDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.icon,
    this.validator,
  });

  final String labelText;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final List<String> items;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField(
      items: items.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon == null ? null : Icon(icon, color: ColorPalette.textColor),
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
      style: const TextStyle(color: ColorPalette.textColor),
      onChanged: onChanged,
      dropdownColor: ColorPalette.darkerSurface,
    );
  }
}
