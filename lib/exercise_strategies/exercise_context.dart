import 'dart:async';

import 'package:daily_drive/exercise_strategies/pushup_detection.strategy.dart';
import 'package:daily_drive/exercise_strategies/rep_detection.strategy.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/exercise_type.model.dart';

class ExerciseContext {

  late RepDetectionStrategy _repDetectionStrategy;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  final Function(int) onRepDetected;
  DateTime? _lastRepTime;
  int _repCount = 0;

  ExerciseContext(ExerciseType exerciseType, this.onRepDetected) {
    if (exerciseType.namePlural == 'Push-ups') {
      _repDetectionStrategy = PushupDetectionStrategy();
    } else {
      throw Exception('Exercise type not supported');
    }
  }

  void startRepDetection() {
    _accelerometerSubscription = userAccelerometerEventStream().listen((event) {
      if(_repDetectionStrategy.detectRep(event.x, event.y, event.z, _lastRepTime)) {
        _repCount++;
        _lastRepTime = DateTime.now();
        onRepDetected(_repCount);
      }
    });
  }

  void stopRepDetection() {
    _accelerometerSubscription?.cancel();
  }

  void reset() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _lastRepTime = null;
    _repCount = 0;
  }

  void dispose() {
    _accelerometerSubscription?.cancel();
  }
}