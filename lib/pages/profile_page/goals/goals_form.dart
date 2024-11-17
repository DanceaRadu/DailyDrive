import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/pages/profile_page/goals/onetime_goal_subform.dart';
import 'package:daily_drive/pages/profile_page/goals/periodic_goal_subform.dart';
import 'package:daily_drive/widgets/main_dropdown.dart';
import 'package:daily_drive/widgets/main_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class GoalsForm extends StatefulWidget {

  final List<ExerciseType> exerciseTypes;

  const GoalsForm({super.key, required this.exerciseTypes});

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {

  String selectedExercise = "";
  String selectedGoalType = "";

  onGoalTypeChanged(String? value) {
    setState(() {
      if(value != null) {
        selectedGoalType = value;
      }
    });
  }

  onExerciseTypeChanged(String? value) {
    setState(() {
      if(value != null) {
        selectedExercise = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return FractionallySizedBox(
      heightFactor: 1.0,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          child: Column(
            children: [
              const Text('Create a new goal', style: TextStyle(fontSize: 20.0)),
              const SizedBox(height: 32.0),
              const MainTextField(labelText: "Goal title"),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                      child: MainDropdown(
                          labelText: "Goal type", 
                          items: const ["One-time", "Periodic"], 
                          onChanged: onGoalTypeChanged
                      )
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: MainDropdown(
                        labelText: "Exercise",
                        items: widget.exerciseTypes.map((e) => e.name).toList(),
                        onChanged: onExerciseTypeChanged
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 16.0),
              if(selectedGoalType == "One-time") OnetimeGoalSubform(
                  exerciseType: widget.exerciseTypes.firstWhereOrNull((element) => element.name == selectedExercise)
              ),
              if(selectedGoalType == "Periodic") PeriodicGoalSubform(
                  exerciseType: widget.exerciseTypes.firstWhereOrNull((element) => element.name == selectedExercise)
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add goal'),
              ),
            ],
          )
        ),
      ),
    );
  }
}
