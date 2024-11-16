import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../color_palette.dart';

class AddGoalCard extends StatelessWidget {

  final void Function(BuildContext) onAddGoalPressed;

  const AddGoalCard({super.key, required this.onAddGoalPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.darkerSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Add goal"),
          const SizedBox(height: 5),
          IconButton(
            onPressed: () {
              onAddGoalPressed(context);
            },
            icon: const Icon(
              Icons.add_circle,
              size: 50,
            ), // Optional: Add color
          ),
        ],
      )
    );
  }
}
