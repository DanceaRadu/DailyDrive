import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/pages/dashboard_page.dart';
import 'package:daily_drive/pages/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'exercise_page/exercise_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activePage = const DashboardPage();
    var activePageTitle = "Home";
    if(_selectedPageIndex == 1) {
      activePage = const ExercisePage();
      activePageTitle = "Exercises";
    }
    if(_selectedPageIndex == 2) {
      activePage = const ProfilePage();
      activePageTitle = "Profile";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: _selectedPageIndex == 2 ? ColorPalette.darkerSurface : ColorPalette.surface,
      ),
      body: activePage,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedPageIndex,
          onTap: _selectPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Exercises"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
        ),
      ),
    );
  }
}
