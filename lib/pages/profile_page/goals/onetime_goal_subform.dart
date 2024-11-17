import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/utils/validators.dart';
import 'package:daily_drive/widgets/main_text_field.dart';
import 'package:flutter/cupertino.dart';

class OnetimeGoalSubform extends StatefulWidget {

  final ExerciseType? exerciseType;
  final TextEditingController goalController;
  const OnetimeGoalSubform({
    super.key,
    required this.exerciseType,
    required this.goalController,
  });

  @override
  State<OnetimeGoalSubform> createState() => _OnetimeGoalSubformState();
}

class _OnetimeGoalSubformState extends State<OnetimeGoalSubform> {
  @override
  Widget build(BuildContext context) {
    if(widget.exerciseType == null) {
      return const Center(
        child: SizedBox(),
      );
    }
    return Column(
      children: [
        MainTextField(
          labelText: "Goal",
          trailingText: widget.exerciseType!.suffix,
          isNumeric: true,
          validator: nullValidator,
          controller: widget.goalController,
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
