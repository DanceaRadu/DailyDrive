import 'package:daily_drive/pages/profile_page/goals/add_goal_card.dart';
import 'package:daily_drive/pages/profile_page/goals/goal_card.dart';
import 'package:daily_drive/pages/profile_page/goals/goals_form.dart';
import 'package:daily_drive/pages/profile_page/goals/repeating_goal_card.dart';
import 'package:daily_drive/providers/combined.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/exercise_type.model.dart';
import '../../../models/goal.model.dart';

class GoalsSummary extends ConsumerWidget {
  const GoalsSummary({super.key});

  void onAddGoalPressed(BuildContext context, List<ExerciseType> exerciseTypes) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,

      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GoalsForm(exerciseTypes: exerciseTypes),
        );
      },
    );
  }

  List<Goal> _filterAndSortGoals(List<Goal> goals) {
    return goals.where((goal) => goal.currentProgress < goal.goal).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      return const Center(
        child: Text('You are not logged in'),
      );
    }
    final combinedData = ref.watch(combinedStreamProvider(user.uid));

    return combinedData.when(
      data: (data) {
        final List<Goal> goals = _filterAndSortGoals(data.goals);
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 0.78,
              ),
              itemCount: goals.length + combinedData.value!.repeatingGoals.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if(index == goals.length + combinedData.value!.repeatingGoals.length) {
                  return AddGoalCard(
                    onAddGoalPressed: (context) => onAddGoalPressed(context, combinedData.value!.exerciseTypes),
                  );
                } else if(index < goals.length) {
                  return GoalCard(goal: goals[index]);
                }
                return RepeatingGoalCard(goal: combinedData.value!.repeatingGoals[index - goals.length]);
              },
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        print('Error loading goals: $error');
        return const SizedBox(
          height: 100,
          child: Center(child: Text('Error loading goals')),
        );
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
