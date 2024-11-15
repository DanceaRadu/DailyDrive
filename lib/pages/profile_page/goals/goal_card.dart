import 'package:daily_drive/color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/goal.model.dart';

class GoalCard extends StatelessWidget {

  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.darkerSurface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(goal.title, style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 20),
            SizedBox(
              height: 130,
              width: 130,
              child: CircularProgressIndicator(
                value: goal.currentProgress / goal.goal,
                backgroundColor: ColorPalette.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(ColorPalette.accent),
                strokeWidth: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
