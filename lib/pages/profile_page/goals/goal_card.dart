import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/pages/goal_page/goal_details_page.dart';
import 'package:daily_drive/providers/exercise_type.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../models/goal.model.dart';

class GoalCard extends ConsumerWidget {

  final Goal goal;

  const GoalCard({super.key, required this.goal});

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
                builder: (context) => GoalDetailsPage(goal: goal),
              ),
            );
          },
          child: Card(
            color: ColorPalette.darkerSurface,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {

                  double parentSize = constraints.maxWidth < constraints.maxHeight
                      ? constraints.maxWidth
                      : constraints.maxHeight;
                  String goalPercentageString = '${((goal.currentProgress / goal.goal) * 100).toInt()}%';

                  return CircularPercentIndicator(
                    radius: parentSize * 0.48,
                    lineWidth: 15,
                    animation: true,
                    percent: goal.currentProgress / goal.goal,
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
                          '${goal.currentProgress} / ${goal.goal}',
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
        );
      },
      loading: () => const SizedBox(height: 50, child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        print('Error loading exercise types: $error');
        return const Center(child: Text('Error loading exercise types'));
      });
  }
}
