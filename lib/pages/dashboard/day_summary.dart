import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../color_palette.dart';

class DaySummary extends StatelessWidget {
  const DaySummary({super.key});

  @override
  Widget build(BuildContext context) {
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
                          percent: 1200 / 3400,
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
                                "456 cal",
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
                          percent: 1200 / 3400,
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
                                "8345",
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
