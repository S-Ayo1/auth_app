import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final authService = AuthService();
  bool hidePassword = true;
  bool hideConfirm = true;

  void pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      dobController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

    void signUp() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        dobController.text.isEmpty ||
        stateController.text.isEmpty ||
        countryController.text.isEmpty ||
        emailController.text.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmController.text) {
      showMessage('Passwords do not match');
      return;
    }

    try {
      await authService.signUp(
        emailController.text,
        passwordController.text,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'dateOfBirth': dobController.text,
        'state': stateController.text,
        'country': countryController.text,
        'email': emailController.text,
      });

      await authService.logOut();

      if (!mounted) return;
      showMessage('Account created. Please log in.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String text = 'Something went wrong. Please try again.';
      if (e.code == 'weak-password') {
        text = 'Password must be at least 6 characters';
      }
      if (e.code == 'email-already-in-use') {
        text = 'This email is already registered';
      }
      if (e.code == 'invalid-email') {
        text = 'Please enter a valid email';
      }
      if (!mounted) return;
      showMessage(text);
    } catch (e) {
      if (!mounted) return;
      showMessage('Could not save your details. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData passwordIcon = Icons.visibility_off;
    if (!hidePassword) {
      passwordIcon = Icons.visibility;
    }

    IconData confirmIcon = Icons.visibility_off;
    if (!hideConfirm) {
      confirmIcon = Icons.visibility;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last name'),
            ),
            TextField(
              controller: dobController,
              readOnly: true,
              onTap: pickDate,
              decoration: InputDecoration(
                labelText: 'Date of birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            TextField(
              controller: stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: countryController,
              decoration: InputDecoration(labelText: 'Country'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(passwordIcon),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: confirmController,
              obscureText: hideConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                suffixIcon: IconButton(
                  icon: Icon(confirmIcon),
                  onPressed: () {
                    setState(() {
                      hideConfirm = !hideConfirm;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}