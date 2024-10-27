import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/firebase_options.dart';
import 'package:daily_drive/pages/home_page.dart';
import 'package:daily_drive/pages/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily.Drive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorPalette.backgroundColor,
          surface: ColorPalette.backgroundColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: ColorPalette.textColor),
          bodyMedium: TextStyle(color: ColorPalette.textColor),
          bodySmall: TextStyle(color: ColorPalette.textColor),
          headlineLarge: TextStyle(color: ColorPalette.textColor),
          headlineMedium: TextStyle(color: ColorPalette.textColor),
          headlineSmall: TextStyle(color: ColorPalette.textColor),
          displayLarge: TextStyle(color: ColorPalette.textColor),
          displayMedium: TextStyle(color: ColorPalette.textColor),
          displaySmall: TextStyle(color: ColorPalette.textColor),
          titleLarge: TextStyle(color: ColorPalette.textColor),
          titleMedium: TextStyle(color: ColorPalette.textColor),
          titleSmall: TextStyle(color: ColorPalette.textColor),
          labelLarge: TextStyle(color: ColorPalette.textColor),
          labelMedium: TextStyle(color: ColorPalette.textColor),
          labelSmall: TextStyle(color: ColorPalette.textColor),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomePage(user: snapshot.data!);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
