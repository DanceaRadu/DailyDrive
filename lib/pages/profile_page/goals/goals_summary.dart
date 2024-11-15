import 'package:daily_drive/pages/profile_page/goals/goal_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/goals.provider.dart';

class GoalsSummary extends ConsumerWidget {
  const GoalsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      return const Center(
        child: Text('You are not logged in'),
      );
    }
    final goalStream = ref.watch(goalsStreamProvider(user.uid));

    return goalStream.when(
      data: (goals) => ListView(
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
            itemCount: goals.length,
            itemBuilder: (BuildContext context, int index) {
              return GoalCard(goal: goals[index]);
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
