import 'package:flutter/material.dart';

class GoalsSummary extends StatefulWidget {
  const GoalsSummary({super.key});

  @override
  State<GoalsSummary> createState() => _GoalsSummaryState();
}

class _GoalsSummaryState extends State<GoalsSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Center(
        child: Text(
          '',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
