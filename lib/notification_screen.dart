import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  final List<String> notifications = const [
    "You missed your 8 AM dose.",
    "New schedule added.",
    "Take Vitamin D at 4 PM today.",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            color: theme.cardColor,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.notifications_active),
              title: Text(notifications[index],
                  style: theme.textTheme.bodyLarge),
            ),
          );
        },
      ),
    );
  }
}
