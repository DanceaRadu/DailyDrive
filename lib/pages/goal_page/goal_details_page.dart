import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/styling_variables.dart';
import 'package:daily_drive/widgets/delete_button.dart';
import 'package:daily_drive/widgets/edit_button.dart';
import 'package:flutter/material.dart';

import '../../models/goal.model.dart';
import '../../services/goals.service.dart';
import '../profile_page/goals/goal_card.dart';

class GoalDetailsPage extends StatelessWidget {

  final Goal goal;
  const GoalDetailsPage({super.key, required this.goal});

  Future<void> _onDelete(BuildContext context) async {
    bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorPalette.darkerSurface,
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this goal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // User cancels
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // User confirms
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      GoalsService goalsService = GoalsService();
      if (goal.goalId == null) {
        return;
      }
      await goalsService.deleteGoal(goal.goalId!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String getEncouragementText() {
    String encouragementText = "";
    if(goal.currentProgress == 0) {
      encouragementText = "You haven't started yet. No worries, you can do it!";
    } else if(goal.currentProgress / goal.goal < 0.25) {
      encouragementText = "You're off to a good start! Let's see if you can keep it going!";
    } else if(goal.currentProgress / goal.goal < 0.5) {
      encouragementText = "You're almost halfway there! Keep it up!";
    } else if(goal.currentProgress / goal.goal < 0.75) {
      encouragementText = "You're almost there! Just a bit more";
    } else if(goal.currentProgress / goal.goal < 1) {
      encouragementText = "You're so close!";
    } else if(goal.currentProgress == goal.goal) {
      encouragementText = "Congratulations! You've reached your goal!";
    }
    return encouragementText;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(goal.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(StylingVariables.pagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 180,
                    width: 170,
                    child: GoalCard(goal: goal, animate: false, showTitle: false)
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: "Goal: ",
                              style: const TextStyle(
                                  color: ColorPalette.accent,
                                  fontWeight: FontWeight.bold
                              ),
                              children: [
                                TextSpan(
                                  text: "${goal.goal}",
                                  style: const TextStyle(color: ColorPalette.onSurface),
                                ),
                              ],
                          ),
                      ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: "Current Progress: ",
                            style: const TextStyle(color: ColorPalette.accent, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: "${goal.currentProgress}",
                                style: const TextStyle(color: ColorPalette.onSurface, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(getEncouragementText())
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EditButton(
                    onEdit: () {},
                    label: "Edit"
                ),
                const SizedBox(width: 10),
                DeleteButton(
                    onDelete: () { _onDelete(context); },
                    label: "Delete"
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
