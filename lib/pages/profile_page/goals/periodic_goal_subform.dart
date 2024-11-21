import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/widgets/main_dropdown.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/validators.dart';
import '../../../widgets/main_text_field.dart';

class PeriodicGoalSubform extends StatefulWidget {

  final ExerciseType? exerciseType;
  final TextEditingController goalController;
  final void Function(String?) onGoalPeriodTypeChanged;

  const PeriodicGoalSubform({
    super.key,
    required this.exerciseType,
    required this.goalController,
    required this.onGoalPeriodTypeChanged,
  });

  @override
  State<PeriodicGoalSubform> createState() => _PeriodicGoalSubformState();
}

class _PeriodicGoalSubformState extends State<PeriodicGoalSubform> {
  @override
  Widget build(BuildContext context) {
    if(widget.exerciseType == null) {
      return const Center(
        child: SizedBox(),
      );
    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: MainTextField(
            labelText: "Goal",
            trailingText: widget.exerciseType!.suffix,
            isNumeric: true,
            validator: nullValidator,
            controller: widget.goalController,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          flex: 1,
          child: MainDropdown(
            labelText: "Period",
            items: const ["Daily", "Weekly", "Monthly"],
            onChanged: widget.onGoalPeriodTypeChanged,
            validator: nullValidator,
          ),
        )
      ],
    );
  }
}
