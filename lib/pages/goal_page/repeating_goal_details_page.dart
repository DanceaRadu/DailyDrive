import 'package:collection/collection.dart';
import 'package:daily_drive/models/goal_period.model.dart';
import 'package:daily_drive/models/repeating_goal.model.dart';
import 'package:daily_drive/pages/goal_page/repeating_goal_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../color_palette.dart';
import '../../models/exercise_type.model.dart';
import '../../providers/combined.provider.dart';
import '../../services/goals.service.dart';
import '../../styling_variables.dart';
import '../../widgets/delete_button.dart';

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
          String title = '${exerciseType.namePlural} - ${goal.goal} ${exerciseType.suffix} ${goal.periodType.toLowerCase()}';
          List<GoalPeriod> sortedPeriods = goal.periods.sorted((a, b) => b.periodStart.compareTo(a.periodStart));

          return Scaffold(
            appBar: AppBar(
              title: Text(goal.title),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(StylingVariables.pagePadding),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    const Divider(
                      color: ColorPalette.darkerSurface, // Color of the line
                      thickness: 4.0,
                      indent: 8.0,
                      endIndent: 8.0,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                          itemCount: sortedPeriods.length + 1,
                          itemBuilder: (context, index) {
                            if(index == sortedPeriods.length) {
                              return Column(
                                children: [
                                  const SizedBox(height: 35),
                                  DeleteButton(
                                      onDelete: () {_onDelete(context, goal);},
                                      label: "Delete"
                                  ),
                                ],
                              );
                            }
                            return RepeatingGoalItem(
                                goal: goal,
                                goalPeriod: sortedPeriods[index]
                            );
                          }
                      ),
                    )
                  ],
                ),
              ),
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
