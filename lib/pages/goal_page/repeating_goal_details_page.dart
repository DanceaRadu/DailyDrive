import 'package:collection/collection.dart';
import 'package:daily_drive/models/repeating_goal.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../color_palette.dart';
import '../../models/exercise_type.model.dart';
import '../../providers/combined.provider.dart';
import '../../services/goals.service.dart';
import '../../styling_variables.dart';

class RepeatingGoalDetailsPage extends ConsumerWidget {

  final String goalId;
  const RepeatingGoalDetailsPage({super.key, required this.goalId});

  Future<void> _onDelete(BuildContext context, RepeatingGoal goal) async {
    bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorPalette.darkerSurface,
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this goal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
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
      await goalsService.deleteRepeatingGoal(goal.goalId!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  RepeatingGoal? getGoal(List<RepeatingGoal> goals, String goalId) {
    return goals.firstWhereOrNull((goal) => goal.goalId == goalId);
  }

  ExerciseType getExerciseType(List<ExerciseType> exerciseTypes, String exerciseTypeId) {
    return exerciseTypes.firstWhere((exerciseType) => exerciseType.exerciseTypeId == exerciseTypeId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(
        child: Text('You are not logged in'),
      );
    }
    final combinedData = ref.watch(combinedStreamProvider(user.uid));

    return combinedData.when(
        data: (data) {
          RepeatingGoal? goal = getGoal(combinedData.value!.repeatingGoals, goalId);
          if(goal == null) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Loading..."),
                ),
                body: const Center(child: CircularProgressIndicator())
            );
          }
          ExerciseType exerciseType = getExerciseType(combinedData.value!.exerciseTypes, goal.exerciseType);

          return Scaffold(
            appBar: AppBar(
              title: Text(goal.title),
            ),
            body: const Padding(
              padding: EdgeInsets.all(StylingVariables.pagePadding),
              child: Placeholder(),
            ),
          );
        },
        error: (error, stackTrace) => Scaffold(
            appBar: AppBar(
              title: const Text("Loading..."),
            ),
            body: const Center(child: Text('Error loading goals'))),
        loading: () => Scaffold(
            appBar: AppBar(
              title: const Text("Loading..."),
            ),
            body: const Center(child: CircularProgressIndicator())));
  }
}
