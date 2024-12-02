import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterNotifier extends StateNotifier<int> {
  StepCounterNotifier() : super(0) {
    _loadSavedSteps();
    _initializePedometer();
  }

  Stream<StepCount>? _stepCountStream;

  Future<void> _loadSavedSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSteps = prefs.getInt(_todayKey()) ?? 0;
    state = savedSteps;
  }

  Future<void> _saveSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_todayKey(), steps);
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}-steps';
  }

  Future<void> _initializePedometer() async {

    bool granted = await Permission.activityRecognition.isGranted;
    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen((StepCount event) {
      final currentSteps = event.steps;

      _saveSteps(currentSteps);
      state = currentSteps;
    }).onError((error) {
      print('Error listening to step count: $error');
    });
  }
}

final stepCounterProvider = StateNotifierProvider<StepCounterNotifier, int>(
      (ref) => StepCounterNotifier(),
);
