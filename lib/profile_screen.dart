import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  final Map<String, String> userData = const {
    'Name': 'John Doe',
    'Email': 'john@example.com',
    'Age': '28',
    'Gender': 'Male',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: userData.entries.map((entry) {
            return Card(
              color: theme.cardColor,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(entry.key, style: theme.textTheme.bodyLarge),
                subtitle: Text(entry.value,
                    style: theme.textTheme.bodyMedium),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
