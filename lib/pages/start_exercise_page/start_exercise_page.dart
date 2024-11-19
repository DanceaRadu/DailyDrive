import 'package:daily_drive/exercise_strategies/exercise_context.dart';
import 'package:flutter/material.dart';

import '../../models/exercise_type.model.dart';

class StartExercisePage extends StatefulWidget {
  const StartExercisePage({super.key, required this.exerciseType});

  final ExerciseType exerciseType;

  @override
  State<StartExercisePage> createState() => _StartExercisePageState();
}

class _StartExercisePageState extends State<StartExercisePage> {

  late ExerciseContext _exerciseContext;
  int _repCount = 0;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _exerciseContext = ExerciseContext(widget.exerciseType, _onRepDetected);
  }

  void _onRepDetected(int repCount) {
    setState(() {
      _repCount = repCount;
    });
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _repCount = 0;
    });
    _exerciseContext.reset();
    _exerciseContext.startRepDetection();
  }

  void _stopTracking() {
    _exerciseContext.stopRepDetection();
    setState(() {
      _isTracking = false;
    });
    //popup whatever else logic idk
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseType.namePlural),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reps: $_repCount',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isTracking ? _stopTracking : _startTracking,
            child: Text(_isTracking ? 'Stop Exercise' : 'Start Exercise'),
          ),
        ],
      ),
    );
  }
}
