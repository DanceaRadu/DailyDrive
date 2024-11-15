import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/pages/profile_page/goals/goals_summary.dart';
import 'package:daily_drive/pages/profile_page/profile_info.dart';
import 'package:daily_drive/pages/profile_page/profile_tab_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../styling_variables.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getTabWidget() {
    switch (selectedIndex) {
      case 0:
        return const GoalsSummary();
      case 1:
        return const Placeholder();
      default:
        return const GoalsSummary();
    }
  }

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    Widget renderedTab = getTabWidget();

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
                      color: ColorPalette.darkerSurface,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ProfileInfo(user: user)
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.fromLTRB(StylingVariables.pagePadding, 0, StylingVariables.pagePadding, 0),
                  child: Column(
                    children: [
                      ProfileTabSelector(selectedIndex: selectedIndex, onTap: onTap),
                      const SizedBox(height: 25),
                      renderedTab,
                      const SizedBox(height: 15),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
