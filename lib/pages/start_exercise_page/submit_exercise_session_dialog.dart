import 'package:daily_drive/utils/validators.dart';
import 'package:daily_drive/widgets/main_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../color_palette.dart';
import '../../models/exercise_type.model.dart';

class SubmitExerciseSessionDialog extends StatefulWidget {

  final int repCount;
  final ExerciseType exerciseType;
  final String elapsedTime;

  const SubmitExerciseSessionDialog({
    super.key,
    required this.repCount,
    required this.exerciseType,
    required this.elapsedTime,
  });

  @override
  State<SubmitExerciseSessionDialog> createState() => _SubmitExerciseSessionDialogState();

  static Future<int?> show(
      BuildContext context, {
        required int repCount,
        required ExerciseType exerciseType,
        required String elapsedTime,
      }) {
    return showDialog<int>(
      context: context,
      builder: (context) => SubmitExerciseSessionDialog(
          repCount: repCount,
          exerciseType: exerciseType,
          elapsedTime: elapsedTime,
      ),
    );
  }
}

class _SubmitExerciseSessionDialogState extends State<SubmitExerciseSessionDialog> {
  late TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.repCount.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Session Summary",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      backgroundColor: ColorPalette.darkerSurface,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(
            "Time: ${widget.elapsedTime}",
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 180,
            child: Form(
              key: _formKey,
              child: MainTextField(
                labelText: widget.exerciseType.suffix,
                controller: controller,
                validator: nullValidator,
                isNumeric: true,
              )

            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final int? enteredNumber = int.tryParse(controller.text);
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(enteredNumber);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
