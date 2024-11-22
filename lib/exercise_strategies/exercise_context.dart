import 'dart:async';

import 'package:daily_drive/exercise_strategies/pullup_detection.strategy.dart';
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
  final LowPassFilter lowPassFilter = LowPassFilter(0.1);

  ExerciseContext(ExerciseType exerciseType, this.onRepDetected) {
    if (exerciseType.namePlural == 'Push-ups') {
      _repDetectionStrategy = PushupDetectionStrategy();
    } else if(exerciseType.namePlural == "Pull-ups") {
      _repDetectionStrategy = PullupDetectionStrategy();
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

  void pauseRepDetection() {

  }

  void resumeRepDetection() {

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

class LowPassFilter {
  double alpha;
  double _filteredX = 0.0;
  double _filteredY = 0.0;
  double _filteredZ = 0.0;

  LowPassFilter(this.alpha);

  Map<String, double> filter(double x, double y, double z) {
    _filteredX = alpha * x + (1 - alpha) * _filteredX;
    _filteredY = alpha * y + (1 - alpha) * _filteredY;
    _filteredZ = alpha * z + (1 - alpha) * _filteredZ;

    return {
      'x': _filteredX,
      'y': _filteredY,
      'z': _filteredZ,
    };
  }
}