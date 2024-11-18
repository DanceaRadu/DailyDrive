import 'package:daily_drive/pages/exercise_page/exercise_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/combined.provider.dart';
import '../../styling_variables.dart';

class ExercisePage extends ConsumerWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      return const Center(
        child: Text('You are not logged in'),
      );
    }
    final combinedData = ref.watch(combinedStreamProvider(user.uid));

    return combinedData.when(
        data: (combinedData) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: StylingVariables.pagePadding),
          child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.9,
              padding: const EdgeInsets.all(10.0),
              children: [
                ExerciseCard(exerciseType: combinedData.exerciseTypes[0], cardColor: const Color(0xFFB172F4), icon: const Icon(Icons.fitness_center)),
                ExerciseCard(exerciseType: combinedData.exerciseTypes[1], cardColor: const Color(0xFFCB8177), icon: const Icon(Icons.sports_basketball)),
                ExerciseCard(exerciseType: combinedData.exerciseTypes[2], cardColor: const Color(0xFFCBC049), icon: const Icon(Icons.sports_tennis)),
              ]
          ),
        ),
        error: (e, stackTrace) => const Center(child: Text('Error loading data')),
        loading: () => const Center(child: CircularProgressIndicator())
    );
  }
}
