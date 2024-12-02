import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../color_palette.dart';
import '../../providers/steps.provider.dart';

class DaySummary extends ConsumerWidget {

  final int calories;
  final int maxCalories = 600;
  final int maxSteps = 150000;

  const DaySummary({
    super.key,
    required this.calories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final stepCount = ref.watch(stepCounterProvider);

    return Card(
      color: ColorPalette.darkerSurface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
            builder: (context, constraints) {

              double availableSize = constraints.maxWidth < constraints.maxHeight
                  ? constraints.maxWidth
                  : constraints.maxHeight;
              availableSize = availableSize / 2 - 8;

              int actualCalories = calories > maxCalories ? 600 : calories;
              int actualSteps = stepCount > maxSteps ? maxSteps : stepCount;

              return Column(
                children: [
                  const Text(
                      "Today's Summary",
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircularPercentIndicator(
                          radius: availableSize / 2 - 2,
                          lineWidth: 20,
                          animation: true,
                          percent: actualCalories / maxCalories,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: ColorPalette.secondary,
                          backgroundColor: ColorPalette.surface,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                size: 34.0,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '$actualCalories cal',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: CircularPercentIndicator(
                          radius: availableSize / 2 - 2,
                          lineWidth: 20,
                          animation: true,
                          animateFromLastPercent: true,
                          percent: actualSteps / maxSteps,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: ColorPalette.accent,
                          backgroundColor: ColorPalette.surface,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/steps.svg',
                                width: 34.0,
                                colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '$actualSteps',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
