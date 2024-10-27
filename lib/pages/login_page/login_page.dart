import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/pages/login_page/login_form_field.dart';
import 'package:daily_drive/widgets/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print(googleUser);
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double availableHeight = constraints.maxHeight - MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: ColorPalette.textColor,
                                size: 120,
                              ),
                              Text(
                                "Daily.Drive",
                                style: TextStyle(
                                  color: ColorPalette.textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          LoginFormField(labelText: "Username", icon: Icons.person, controller: _usernameController),
                          const SizedBox(height: 25),
                          LoginFormField(labelText: "Password", icon: Icons.password, obscureText: true, controller: _passwordController),
                          const SizedBox(height: 40),
                          MainButton(text: 'Login', onPressed: () {}),
                          const SizedBox(height: 20),
                          const Text(
                            "OR",
                            style: TextStyle(
                              color: Color(0xFF7F7F7F),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _signInWithGoogle,
                            icon: Image.asset(
                              'assets/images/google_icon.png',
                              height: 24,
                              width: 24,
                            ),
                            label: const Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorPalette.invertedTextColor,
                                ),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                      const Text(
                        "Don't have an account? Create one here.",
                        style: TextStyle(
                          color: ColorPalette.textColor,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}