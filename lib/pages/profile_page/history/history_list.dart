import 'package:daily_drive/color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/goal.model.dart';
import '../../../providers/combined.provider.dart';

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  List<Goal> _filterAndSortGoals(List<Goal> goals) {
    return goals.where((goal) => goal.currentProgress >= goal.goal).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  String formatNumber(num number) {
    if (number == number.round()) {
      return number.round().toString();
    }
    return number.toString();
  }

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
      data: (data) {
        List<Goal> goals = _filterAndSortGoals(data.goals);

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goals.length,
          itemBuilder: (BuildContext context, int index) {
            final goal = goals[index];
            final exerciseType = data.exerciseTypes.firstWhere((element) => element.exerciseTypeId == goal.exerciseType);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorPalette.darkerSurface, // Dark background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    exerciseType.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                  subtitle: Text(
                    '${exerciseType.namePlural} | ${formatNumber(goal.goal)} ${exerciseType.suffix}',
                    style: const TextStyle(
                      fontSize: 13
                    ),
                  ),
                  trailing: Text(
                    '${goal.createdAt.day}/${goal.createdAt.month}/${goal.createdAt.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorPalette.textColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            );
          },

        );
      },
      error: (error, stackTrace) {
        print('Error loading history: $error');
        return const SizedBox(
          height: 100,
          child: Center(child: Text('Error loading history.')),
        );
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
