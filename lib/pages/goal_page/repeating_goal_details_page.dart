import 'package:flutter/material.dart';

class RepeatingGoalDetailsPage extends StatelessWidget {

  final String goalId;
  const RepeatingGoalDetailsPage({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goalId),
      ),
      body: const Placeholder(),
    );
  }
}
