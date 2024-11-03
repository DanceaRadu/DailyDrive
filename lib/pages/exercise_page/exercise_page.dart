import 'package:daily_drive/pages/exercise_page/exercise_card.dart';
import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 0.9,
        padding: const EdgeInsets.all(10.0),
        children: const [
          ExerciseCard(text: Text('Push-ups'), cardColor: Color(0xFFB172F4), icon: Icon(Icons.fitness_center)),
          ExerciseCard(text: Text('Sit-ups'), cardColor: Color(0xFFCB8177), icon: Icon(Icons.sports_basketball)),
          ExerciseCard(text: Text('Squats'), cardColor: Color(0xFFCBC049), icon: Icon(Icons.sports_tennis)),
          ExerciseCard(text: Text('Pull-ups'), cardColor: Color(0xFF6FBDBD), icon: Icon(Icons.surfing)),
          ExerciseCard(text: Text('Jogging'), cardColor: Color(0xFF94D078), icon: Icon(Icons.sports_football)),
          ExerciseCard(text: Text('Jogging'), cardColor: Color(0xFF53B093), icon: Icon(Icons.sports_baseball_outlined)),
        ]
      ),
    );
  }
}
