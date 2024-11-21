import 'package:daily_drive/services/goals.service.dart';
import 'package:riverpod/riverpod.dart';

import '../models/goal.model.dart';
import '../models/repeating_goal.model.dart';

final goalServiceProvider = Provider<GoalsService>((ref) {
  return GoalsService();
});

final goalsStreamProvider = StreamProvider.family<List<Goal>, String>((ref, userId) {
  final goalService = ref.watch(goalServiceProvider);
  return goalService.getGoals(userId);
});

final repeatingGoalsStreamProvider = StreamProvider.family<List<RepeatingGoal>, String>((ref, userId) {
  final goalService = ref.watch(goalServiceProvider);
  return goalService.getRepeatingGoals(userId);
});
