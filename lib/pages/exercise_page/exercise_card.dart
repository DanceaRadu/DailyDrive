import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/pages/jogging/jogging_page.dart';
import 'package:daily_drive/pages/start_exercise_page/start_exercise_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exerciseType,
    required this.cardColor,
    required this.icon,
  });

  final Color cardColor;
  final ExerciseType exerciseType;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if(exerciseType.name == 'Jogging') {
                return const JoggingPage();
              }
              return StartExercisePage(exerciseType: exerciseType);
            })
        );
      },
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 1),
              Icon(
                icon.icon,
                color: Colors.white.withOpacity(0.8),
                size: icon.size ?? 50.0,
              ),
              Text(
                exerciseType.namePlural,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
