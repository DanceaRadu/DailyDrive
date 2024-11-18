import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/exercise_type.model.dart';

class StartExercisePage extends StatefulWidget {
  const StartExercisePage({super.key, required this.exerciseType});

  final ExerciseType exerciseType;

  @override
  State<StartExercisePage> createState() => _StartExercisePageState();
}

class _StartExercisePageState extends State<StartExercisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseType.namePlural),
      ),
      body: const Center(
        child: Text('Start Exercise'),
      ),
    );
  }
}
