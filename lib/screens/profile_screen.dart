import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  String dateOfBirth = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!mounted) return;
    final data = doc.data();
    if (data == null) return;

    setState(() {
      firstNameController.text = data['firstName'] ?? '';
      lastNameController.text = data['lastName'] ?? '';
      stateController.text = data['state'] ?? '';
      countryController.text = data['country'] ?? '';
      dateOfBirth = data['dateOfBirth'] ?? '';
    });
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  void saveProfile() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'state': stateController.text,
        'country': countryController.text,
      }, SetOptions(merge: true));

      if (!mounted) return;
      showMessage('Profile saved');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showMessage('Could not save. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    String email = '';
    if (user != null) {
      email = '${user.email}';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            Text('Date of birth: $dateOfBirth'),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last name'),
            ),
            TextField(
              controller: stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: countryController,
              decoration: InputDecoration(labelText: 'Country'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}