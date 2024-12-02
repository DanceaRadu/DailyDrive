import 'package:daily_drive/models/exercise_session.model.dart';
import 'package:daily_drive/pages/dashboard/day_summary.dart';
import 'package:daily_drive/services/exercise_session.service.dart';
import 'package:daily_drive/styling_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {

  const DashboardPage({super.key});

  num calculateCaloriesFromSessions(List<ExerciseSession> sessions) {
    return sessions.fold(0, (previousValue, element) => previousValue + element.calories);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('You are not logged in'),
      );
    }

    final ExerciseSessionService exerciseSessionService = ExerciseSessionService();

    return Padding(
      padding: const EdgeInsets.all(StylingVariables.pagePadding),
      child: FutureBuilder<List<ExerciseSession>>(
        future: exerciseSessionService.getSessionsForToday(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            int calories = calculateCaloriesFromSessions(snapshot.data!).toInt();
            return SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  DaySummary(calories: calories),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}