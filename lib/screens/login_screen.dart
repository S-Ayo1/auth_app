import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  String errorMessage = '';

    void logIn() async {
      try {
        await authService.logIn(
          emailController.text,
          passwordController.text,
        );
        if (!mounted) return;
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String text = 'Something went wrong. Please try again.';
        if (e.code == 'invalid-credential') {
          text = 'Incorrect email or password';
        }
        if (e.code == 'invalid-email') {
          text = 'Please enter a valid email';
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: logIn,
              child: Text('Log In'),
            ),
            Text(errorMessage),
          ],
        ),
      ),
    );
  }
}