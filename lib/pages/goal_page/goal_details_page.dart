import 'package:collection/collection.dart';
import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/styling_variables.dart';
import 'package:daily_drive/widgets/delete_button.dart';
import 'package:daily_drive/widgets/edit_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/goal.model.dart';
import '../../providers/combined.provider.dart';
import '../../services/goals.service.dart';
import '../profile_page/goals/goal_card.dart';

class GoalDetailsPage extends ConsumerWidget {
  final String goalId;

  const GoalDetailsPage({super.key, required this.goalId});

  Future<void> _onDelete(BuildContext context, Goal goal) async {
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
      await goalsService.deleteGoal(goal.goalId!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Goal? getGoal(List<Goal> goals, String goalId) {
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
          Goal? goal = getGoal(combinedData.value!.goals, goalId);
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
                            child: GoalCard(
                                goal: goal,
                                animate: false,
                                showTitle: false
                            )
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
                                  style: const TextStyle(
                                      color: ColorPalette.accent,
                                      fontWeight: FontWeight.bold
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${goal.currentProgress}",
                                      style: const TextStyle(
                                          color: ColorPalette.onSurface,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(goal.getEncouragementText())
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EditButton(onEdit: () {}, label: "Edit"),
                        const SizedBox(width: 10),
                        DeleteButton(
                            onDelete: () {_onDelete(context, goal);},
                            label: "Delete"
                        )
                      ],
                    )
                  ],
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
