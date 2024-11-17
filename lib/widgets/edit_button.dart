import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../color_palette.dart';

class EditButton extends StatelessWidget {

  final String label;
  final void Function() onEdit;

  const EditButton({
    super.key,
    required this.onEdit,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onEdit,
      icon: const Icon(Icons.edit, color: ColorPalette.accent),
      label: Text(
        label,
        style: const TextStyle(color: ColorPalette.accent),
      ),
    );
  }
}
