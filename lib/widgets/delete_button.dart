import 'package:daily_drive/color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {

  final String label;
  final void Function() onDelete;

  const DeleteButton({
    super.key,
    required this.onDelete,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onDelete,
      icon: const Icon(Icons.delete, color: ColorPalette.errorColor),
      label: Text(
        label,
        style: const TextStyle(color: ColorPalette.errorColor),
      ),
    );
  }
}
