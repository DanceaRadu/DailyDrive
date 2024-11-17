import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/validators.dart';
import '../../widgets/main_button.dart';
import 'auth_form_field.dart';
import 'error_dialog.dart';

class RegisterForm extends StatefulWidget {
  final FirebaseAuth auth;

  const RegisterForm({super.key, required this.auth});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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

  Future<void> _register() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Registration error", "Passwords do not match.");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(_usernameController.text.trim());
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog('Registration error', 'Failed to register.');
    } catch (e) {
      _showErrorDialog('Registration error', 'Unknown error occurred.');
    } finally {
      setState(() {
        isLoading = false;
      });
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
          AuthFormField(labelText: "Username", icon: Icons.account_circle, controller: _usernameController, validator: nullValidator),
          const SizedBox(height: 25),
          AuthFormField(labelText: "Password", icon: Icons.password, obscureText: true, controller: _passwordController, validator: passwordValidator),
          const SizedBox(height: 25),
          AuthFormField(labelText: "Confirm Password", icon: Icons.password, obscureText: true, controller: _confirmPasswordController, validator: nullValidator),
          const SizedBox(height: 30),
          MainButton(text: 'Register', onPressed: _register, isLoading: isLoading),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
