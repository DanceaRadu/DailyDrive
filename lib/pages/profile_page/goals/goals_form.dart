import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/pages/profile_page/goals/onetime_goal_subform.dart';
import 'package:daily_drive/pages/profile_page/goals/periodic_goal_subform.dart';
import 'package:daily_drive/services/goals.service.dart';
import 'package:daily_drive/utils/validators.dart';
import 'package:daily_drive/widgets/main_dropdown.dart';
import 'package:daily_drive/widgets/main_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../models/goal.model.dart';
import '../../../widgets/main_button.dart';

class GoalsForm extends StatefulWidget {

  final List<ExerciseType> exerciseTypes;

  const GoalsForm({super.key, required this.exerciseTypes});

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {

  String selectedExercise = "";
  String selectedGoalType = "";
  bool isLoading = false;
  final _titleController = TextEditingController();
  final _goalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _handleAddGoal() async {

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        GoalsService goalsService = GoalsService();
        final User? user = FirebaseAuth.instance.currentUser;
        if(user == null) {
          throw Exception("User is not logged in");
        }
        String exerciseId = widget.exerciseTypes.firstWhereOrNull((element) => element.name == selectedExercise)?.exerciseTypeId ?? "";
        await goalsService.addGoal(Goal(
            userId: user.uid,
            exerciseType: exerciseId,
            title: _titleController.text,
            createdAt: DateTime.now(),
            currentProgress: 0,
            goal: double.parse(_goalController.text)
        ));
      } catch (e) {
        print("Error: $e");
      } finally {
        setState(() {
          isLoading = false;
          Navigator.pop(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return FractionallySizedBox(
      heightFactor: 1.0,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Create a new goal', style: TextStyle(fontSize: 20.0)),
              const SizedBox(height: 32.0),
              MainTextField(
                labelText: "Goal title",
                controller: _titleController,
                validator: nullValidator,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                      child: MainDropdown(
                          labelText: "Goal type",
                          items: const ["One-time", "Periodic"],
                          onChanged: onGoalTypeChanged,
                          validator: nullValidator,
                      )
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: MainDropdown(
                        labelText: "Exercise",
                        items: widget.exerciseTypes.map((e) => e.name).toList(),
                        onChanged: onExerciseTypeChanged,
                        validator: nullValidator,
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 16.0),
              if(selectedGoalType == "One-time") OnetimeGoalSubform(
                  exerciseType: widget.exerciseTypes.firstWhereOrNull((element) => element.name == selectedExercise),
                  goalController: _goalController
              ),
              if(selectedGoalType == "Periodic") PeriodicGoalSubform(
                  exerciseType: widget.exerciseTypes.firstWhereOrNull((element) => element.name == selectedExercise)
              ),
              const SizedBox(height: 16.0),
              MainButton(
                  text: 'Add goal',
                  onPressed: _handleAddGoal,
                  isLoading: isLoading
              )
            ],
          )
        ),
      ),
    );
  }
}
