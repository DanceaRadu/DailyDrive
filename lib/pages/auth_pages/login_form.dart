import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../color_palette.dart';
import '../../utils/validators.dart';
import '../../widgets/main_button.dart';
import 'auth_form_field.dart';
import 'error_dialog.dart';

class LoginForm extends StatefulWidget {

  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  const LoginForm({super.key, required this.auth, required this.googleSignIn});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void _showErrorDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(title: title, message: message);
        }
    );
  }

  Future<User?> _signInWithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });
      final GoogleSignInAccount? googleUser = await widget.googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          isLoading = false;
          _showErrorDialog('Login error', 'Something went wrong.');
        });
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await widget.auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      setState(() {
        isLoading = false;
        _showErrorDialog('Login error', 'Something went wrong.');
      });
      return null;
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        await widget.auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _passwordController.clear();
          isLoading = false;
          _showErrorDialog('Login error', 'Please check your email and password and try again.');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthFormField(labelText: "Email", icon: Icons.mail, controller: _emailController, validator: emailValidator),
          const SizedBox(height: 25),
          AuthFormField(labelText: "Password", icon: Icons.password, obscureText: true, controller: _passwordController, validator: nullValidator),
          const SizedBox(height: 40),
          MainButton(text: 'Login', onPressed: _login, isLoading: isLoading),
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
