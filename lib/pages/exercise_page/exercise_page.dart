import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/pages/exercise_page/exercise_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/combined.provider.dart';
import '../../styling_variables.dart';

Map<String, Icon> iconMap = {
  "fitness_center": const Icon(Icons.fitness_center),
  "sports_handball": const Icon(Icons.sports_handball),
  "rowing": const Icon(Icons.rowing),
  "directions_run": const Icon(Icons.directions_run),
  "arrow_upward": const Icon(Icons.arrow_upward),
};

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
              children: List.generate(combinedData.exerciseTypes.length,
                  (index) {
                    ExerciseType type = combinedData.exerciseTypes[index];
                    return ExerciseCard(
                        exerciseType: type,
                        cardColor: Color(int.parse(type.color)),
                        icon: iconMap[type.icon]!
                    );
                  }
              )
          ),
        ),
        error: (e, stackTrace) => const Center(child: Text('Error loading data')),
        loading: () => const Center(child: CircularProgressIndicator())
    );
  }
}
