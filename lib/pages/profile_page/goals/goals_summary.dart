import 'package:daily_drive/pages/profile_page/goals/add_goal_card.dart';
import 'package:daily_drive/pages/profile_page/goals/goal_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/goals.provider.dart';

class GoalsSummary extends ConsumerWidget {
  const GoalsSummary({super.key});

  void onAddGoalPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true, // Optional: Allows for full-screen or larger content
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts height based on child content
            children: [
              const Text(
                "Add a New Goal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Goal Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle goal submission
                  print("Goal added");
                  Navigator.pop(context); // Close the modal
                },
                child: const Text("Submit"),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
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
            itemCount: goals.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if(index == goals.length) {
                return AddGoalCard(onAddGoalPressed: onAddGoalPressed);
              }
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
