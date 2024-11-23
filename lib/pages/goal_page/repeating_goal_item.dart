import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/models/goal_period.model.dart';
import 'package:daily_drive/models/repeating_goal.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
    String formattedDate = DateFormat('d MMM y').format(goalPeriod.periodStart);

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                icon,
                color: iconColor,
                size: 50.0,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Text(formattedDate)
                  ),
                  const SizedBox(height: 5),
                  LinearPercentIndicator(
                    lineHeight: 20.0,
                    percent: goalPeriod.progress / goal.goal,
                    backgroundColor: ColorPalette.darkerSurface,
                    progressColor: iconColor,
                    animation: true,
                    barRadius: const Radius.circular(8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50.0,
                  height: 45,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      percentageString,
                      style: const TextStyle(
                        color: ColorPalette.textColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}
