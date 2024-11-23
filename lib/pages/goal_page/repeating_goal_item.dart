import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/models/goal_period.model.dart';
import 'package:daily_drive/models/repeating_goal.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RepeatingGoalItem extends StatelessWidget {

  final RepeatingGoal goal;
  final GoalPeriod goalPeriod;

  const RepeatingGoalItem({
    super.key,
    required this.goal,
    required this.goalPeriod,
  });

  @override
  Widget build(BuildContext context) {

    Color iconColor;
    IconData icon;
    bool isOngoing = false;
    bool isCompleted = false;

    if(goalPeriod.periodStart.isBefore(DateTime.now()) && goalPeriod.periodEnd.isAfter(DateTime.now())) {
      isOngoing = true;
      iconColor = ColorPalette.ongoingColor;
      icon = Icons.pending;
    }
    else if(goal.goal <= goalPeriod.progress) {
      isCompleted = true;
      iconColor = ColorPalette.accent;
      icon = Icons.check_circle;
    } else {
      iconColor = ColorPalette.errorColor;
      icon = Icons.cancel;
    }

    String percentageString = '${(goalPeriod.progress / goal.goal * 100).toStringAsFixed(0)}%';

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 45.0,
            ),
            Expanded(
              child: const Column(
                children: [
                  Text("asdasdasd"),
                  Text("asdasdasdasd")
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  percentageString,
                  style: const TextStyle(
                    color: ColorPalette.textColor,
                    fontSize: 16.0,
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}
