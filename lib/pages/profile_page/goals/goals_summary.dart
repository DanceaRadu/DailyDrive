import 'package:daily_drive/pages/profile_page/goals/add_goal_card.dart';
import 'package:daily_drive/pages/profile_page/goals/goal_card.dart';
import 'package:daily_drive/pages/profile_page/goals/goals_form.dart';
import 'package:daily_drive/pages/profile_page/goals/repeating_goal_card.dart';
import 'package:daily_drive/providers/combined.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/exercise_type.model.dart';

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
      data: (data) => ListView(
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
              childAspectRatio: 0.85,
            ),
            itemCount: combinedData.value!.repeatingGoals.length,
            itemBuilder: (BuildContext context, int index) {
              return RepeatingGoalCard(goal: combinedData.value!.repeatingGoals[index]);
            },
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 0.85,
            ),
            itemCount: combinedData.value!.goals.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if(index == combinedData.value!.goals.length) {
                return AddGoalCard(
                  onAddGoalPressed: (context) => onAddGoalPressed(context, combinedData.value!.exerciseTypes),
                );
              }
              return GoalCard(goal: combinedData.value!.goals[index]);
            },
          ),
        ],
      ),
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
