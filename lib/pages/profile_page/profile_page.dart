import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/pages/profile_page/goals_summary.dart';
import 'package:daily_drive/pages/profile_page/profile_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: double.infinity),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 3,
                          offset: Offset(0, 4),
                        ),
                      ],
                      color: ColorPalette.secondary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ProfileInfo(user: user)
                ),
                const SizedBox(height: 32),
                const Text(
                  "Goals",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const GoalsSummary(),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color.fromARGB(150, 255, 0, 0), width: 2.0), // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button padding
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Color.fromARGB(150, 255, 0, 0), // Icon color to match border
                      ),
                      SizedBox(width: 8), // Spacing between icon and text
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Color.fromARGB(150, 255, 0, 0), // Text color to match border
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
