import 'package:daily_drive/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/goal.model.dart';
import '../../services/goals.service.dart';

class GoalDetailsPage extends StatelessWidget {

  final Goal goal;
  const GoalDetailsPage({super.key, required this.goal});

  Future<void> _onDelete(BuildContext context) async {
    GoalsService goalsService = GoalsService();
    if(goal.goalId == null) {
      return;
    }
    await goalsService.deleteGoal(goal.goalId!);
    if(context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Goal: ${goal.goal}'),
            Text('Current Progress: ${goal.currentProgress}'),
            MainButton(text: "Delete", onPressed: () => _onDelete(context)),
          ],
        ),
      ),
    );
  }
}
