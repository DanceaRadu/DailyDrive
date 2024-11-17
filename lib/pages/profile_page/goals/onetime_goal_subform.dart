import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/widgets/main_text_field.dart';
import 'package:flutter/cupertino.dart';

class OnetimeGoalSubform extends StatefulWidget {

  final ExerciseType? exerciseType;
  const OnetimeGoalSubform({super.key, required this.exerciseType});

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
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
