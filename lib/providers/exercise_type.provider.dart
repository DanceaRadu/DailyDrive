import 'package:daily_drive/services/exercise_type.service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exercise_type.model.dart';

final exerciseTypeServiceProvider = Provider<ExerciseTypesService>((ref) {
  return ExerciseTypesService();
});

final exerciseTypesStreamProvider = StreamProvider<List<ExerciseType>>((ref) {
  final exerciseTypesProvider = ref.watch(exerciseTypeServiceProvider);
  return exerciseTypesProvider.getExerciseTypes();
});