import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/pages/auth_pages/login_form.dart';
import 'package:daily_drive/pages/auth_pages/register_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool showLoginForm = true;
  String changeButtonText = "Don't have an Account ? Create one here.";

  void _changeForm() {
    setState(() {
      showLoginForm = !showLoginForm;
      changeButtonText = showLoginForm ? "Don't have an Account ? Create one here." : "Already have an Account ? Login here.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.surface,
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
                      showLoginForm ? LoginForm(auth: _auth, googleSignIn: _googleSignIn) : RegisterForm(auth: _auth),
                      TextButton(
                        onPressed: _changeForm,
                        child: Text(
                          changeButtonText,
                          style: const TextStyle(
                            color: ColorPalette.textColor,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
}