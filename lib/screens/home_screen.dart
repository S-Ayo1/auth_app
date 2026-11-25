import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../auth_service.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fullName = '';

  @override
  void initState() {
    super.initState();
    loadName();
  }

  void loadName() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!mounted) return;
    final data = doc.data();
    if (data == null) return;

    String firstName = data['firstName'] ?? '';
    String lastName = data['lastName'] ?? '';

    setState(() {
      fullName = '$firstName $lastName';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    String email = '';
    if (user != null) {
      email = '${user.email}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              if (!mounted) return;
              loadName();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $fullName', style: TextStyle(fontSize: 24)),
            Text(email),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AuthService().logOut();
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}