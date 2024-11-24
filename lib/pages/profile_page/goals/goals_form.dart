import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/models/repeating_goal.model.dart';
import 'package:daily_drive/pages/profile_page/goals/onetime_goal_subform.dart';
import 'package:daily_drive/pages/profile_page/goals/periodic_goal_subform.dart';
import 'package:daily_drive/services/goals.service.dart';
import 'package:daily_drive/utils/validators.dart';
import 'package:daily_drive/widgets/main_dropdown.dart';
import 'package:daily_drive/widgets/main_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../models/goal.model.dart';
import '../../../models/goal_period.model.dart';
import '../../../widgets/main_button.dart';

class GoalsForm extends StatefulWidget {

  final List<ExerciseType> exerciseTypes;

  const GoalsForm({super.key, required this.exerciseTypes});

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {

  GoalsService goalsService = GoalsService();

  String selectedExercise = "";
  String selectedGoalType = "";
  bool isLoading = false;
  final _titleController = TextEditingController();
  final _goalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedGoalPeriodType = "";

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

  onGoalPeriodTypeChanged(String? value) {
    setState(() {
      if(value != null) {
        selectedGoalPeriodType = value;
      }
    });
  }

  Future<void> _handleAddGoal() async {
    if(!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if(user == null) {
        throw Exception("User is not logged in");
      }
      String exerciseId = widget.exerciseTypes.firstWhereOrNull((element) => element.name == selectedExercise)?.exerciseTypeId ?? "";

      if(selectedGoalType == "Periodic") {
        await _addPeriodicGoal(user, exerciseId);
      } else if(selectedGoalType == "One-time") {
        await _addOnetimeGoal(user, exerciseId);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    } finally {
      setState(() {
        isLoading = false;
        Navigator.pop(context);
      });
    }
  }

  _addPeriodicGoal(User user, String goalId) async {
    goalsService.addRepeatingGoal(RepeatingGoal(
        userId: user.uid,
        exerciseType: goalId,
        title: _titleController.text,
        goal: double.parse(_goalController.text),
        periods: [getFirstPeriodForPeriodicGoal(selectedGoalPeriodType)],
        periodType: selectedGoalPeriodType,
    ));
  }

  _addOnetimeGoal(User user, String exerciseId) async {
    goalsService.addGoal(Goal(
        userId: user.uid,
        exerciseType: exerciseId,
        title: _titleController.text,
        createdAt: DateTime.now(),
        currentProgress: 0,
        goal: double.parse(_goalController.text)
    ));
  }

  GoalPeriod getFirstPeriodForPeriodicGoal(String periodType) {
    int daysOffset;
    switch(periodType) {
      case "Daily": daysOffset = 1;
      case "Weekly": daysOffset = 7;
      case "Monthly": daysOffset = 30;
      default: daysOffset = 1;
    }
    return GoalPeriod(
      periodStart: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          0,
          0
      ),
      periodEnd: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          0, // Hour
          0 // 5 minutes past midnight
      ).add(Duration(days: daysOffset)),
      progress: 0,
    );
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
                  exerciseType: widget.exerciseTypes.firstWhereOrNull((element) => element.name == selectedExercise),
                  goalController: _goalController,
                  onGoalPeriodTypeChanged: onGoalPeriodTypeChanged
              ),
              const SizedBox(height: 24.0),
              MainButton(
                  text: 'Add goal',
                  onPressed: _handleAddGoal,
                  isLoading: isLoading
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          )
        ),
      ),
    );
  }
}
