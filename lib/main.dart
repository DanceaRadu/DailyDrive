import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/firebase_options.dart';
import 'package:daily_drive/pages/auth_pages/auth_page.dart';
import 'package:daily_drive/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
    seedColor: ColorPalette.seedColor,
    surface: ColorPalette.surface,
    onSurface: ColorPalette.onSurface,
    secondary: ColorPalette.secondary,
);

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
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: ColorPalette.surface,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: ColorPalette.surface,
          foregroundColor: ColorPalette.onSurface,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: ColorPalette.onSurface,
          selectedItemColor: ColorPalette.secondary,
          unselectedItemColor: ColorPalette.surface,
        ),
        textTheme: ThemeData().textTheme.copyWith(
          displayLarge: ThemeData().textTheme.displayLarge?.copyWith(letterSpacing: 1.1),
          displayMedium: ThemeData().textTheme.displayMedium?.copyWith(letterSpacing: 1.1),
          displaySmall: ThemeData().textTheme.displaySmall?.copyWith(letterSpacing: 1.1),
          headlineMedium: ThemeData().textTheme.headlineMedium?.copyWith(letterSpacing: 1.1),
          headlineSmall: ThemeData().textTheme.headlineSmall?.copyWith(letterSpacing: 1.1),
          titleMedium: ThemeData().textTheme.titleMedium?.copyWith(letterSpacing: 1.1),
          titleSmall: ThemeData().textTheme.titleSmall?.copyWith(letterSpacing: 1.1),
          bodyLarge: ThemeData().textTheme.bodyLarge?.copyWith(letterSpacing: 1.1),
          bodyMedium: ThemeData().textTheme.bodyMedium?.copyWith(letterSpacing: 1.1),
          bodySmall: ThemeData().textTheme.bodySmall?.copyWith(letterSpacing: 1.1),
          labelLarge: ThemeData().textTheme.labelLarge?.copyWith(letterSpacing: 1.1),
          labelSmall: ThemeData().textTheme.labelSmall?.copyWith(letterSpacing: 1.1),
          titleLarge: ThemeData().textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0
          )
        )
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
          return const AuthPage();
        }
      },
    );
  }
}
