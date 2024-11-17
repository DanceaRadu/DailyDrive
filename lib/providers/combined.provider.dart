import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise_type.model.dart';
import '../models/goal.model.dart';
import 'exercise_type.provider.dart';
import 'goals.provider.dart';

final combinedStreamProvider = Provider.family<AsyncValue<CombinedData>, String>((ref, userId) {
  final AsyncValue<List<Goal>> goalsStream = ref.watch(goalsStreamProvider(userId));
  final AsyncValue<List<ExerciseType>> exerciseTypesStream = ref.watch(exerciseTypesStreamProvider);

  final List<AsyncValue<dynamic>> asyncValues = [
    goalsStream,
    exerciseTypesStream
  ];

  if (asyncValues.any((asyncValue) => asyncValue.isLoading)) {
    return const AsyncValue<CombinedData>.loading();
  }

  if (asyncValues.any((asyncValue) => asyncValue.error != null)) {
    return AsyncValue.error(
      asyncValues.firstWhere((asyncValue) => asyncValue.error != null).error!,
      asyncValues.firstWhere((asyncValue) => asyncValue.error != null).stackTrace!
    );
  }

  if(asyncValues.every((asyncValue) => asyncValue.hasValue)) {
    return AsyncValue.data(
      CombinedData(
        goals: asyncValues[0].value,
        exerciseTypes: asyncValues[1].value,
      )
    );
  }
  return const AsyncValue.loading();
});

class CombinedData {
  final List<Goal> goals;
  final List<ExerciseType> exerciseTypes;

  CombinedData({
    required this.goals,
    required this.exerciseTypes,
  });
}