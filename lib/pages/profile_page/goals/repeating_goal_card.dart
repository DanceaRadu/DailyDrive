import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/models/repeating_goal.model.dart';
import 'package:daily_drive/pages/goal_page/repeating_goal_details_page.dart';
import 'package:daily_drive/providers/exercise_type.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../models/goal_period.model.dart';

class RepeatingGoalCard extends ConsumerWidget {

  final RepeatingGoal goal;

  const RepeatingGoalCard({
    super.key,
    required this.goal,
  });

  String formatNumber(num number) {
    if (number == number.round()) {
      return number.round().toString();
    }
    return number.toString();
  }

  num getCurrentProgress() {
    GoalPeriod? latestPeriod = goal.getLatestPeriod();
    if(latestPeriod == null) {
      return 0;
    }
    return latestPeriod.progress;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final exerciseTypesStream = ref.watch(exerciseTypesStreamProvider);

    return exerciseTypesStream.when(
        data: (exerciseTypes) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RepeatingGoalDetailsPage(goalId: goal.goalId!),
                ),
              );
            },
            child: SizedBox.expand(
              child: Card(
                color: ColorPalette.darkerSurface,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                      builder: (context, constraints) {

                        double availableSize = constraints.maxWidth < constraints.maxHeight
                            ? constraints.maxWidth
                            : constraints.maxHeight;
                        String goalPercentageString = '${((getCurrentProgress() / goal.goal) * 100).toInt()}%';
                        String goalProgressString = '${formatNumber(getCurrentProgress())} / ${formatNumber(goal.goal)}';

                        return CircularPercentIndicator(
                          radius: availableSize / 2 - 2,
                          lineWidth: 15,
                          animation: true,
                          percent: getCurrentProgress() / goal.goal,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: ColorPalette.accent,
                          backgroundColor: ColorPalette.surface,
                          header: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              goal.title,
                            ),
                          ),
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                goalPercentageString,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                goalProgressString,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const SizedBox(height: 50, child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error loading exercise types: $error');
          return const Center(child: Text('Error loading exercise types'));
        });
  }
}
