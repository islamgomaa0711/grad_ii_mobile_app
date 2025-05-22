import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get text color based on theme (black for light mode and white for dark mode)
    final textColor = theme.brightness == Brightness.dark ? Colors.black : Colors.white;

    // Get icon color based on theme (black for dark mode and white for light mode)
    final iconColor = theme.brightness == Brightness.dark ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'monitoring'.tr(),  // Dynamic translation for "Monitoring"
          style: TextStyle(color: textColor),  // Button text color based on the theme
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Monitoring Title
            Text(
              'monitoring_status'.tr(),  // Dynamic translation for "Monitoring Status"
              style: GoogleFonts.poppins().copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: textColor,  // White or black text depending on theme
              ),
            ),
            const SizedBox(height: 20),

            // Sample monitoring content (just for illustration)
            Card(
              color: theme.cardColor,
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.monitor_heart, color: iconColor),  // Dynamic icon color based on theme
                title: Text(
                  'heart_rate'.tr(),  // Dynamic translation for "Heart Rate"
                  style: TextStyle(color: textColor),  // White or black text depending on theme
                ),
                subtitle: Text(
                  'current_heart_rate'.tr() + ': 75 bpm',  // Dynamic translation for heart rate value
                  style: TextStyle(color: textColor),  // White or black text depending on theme
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sample button (Adjust as necessary for your design)
            ElevatedButton.icon(
              onPressed: () {
                // Action for button press
              },
              icon: Icon(Icons.refresh, color: iconColor),  // Dynamic icon color based on theme
              label: Text(
                'refresh'.tr(),  // Dynamic translation for "Refresh"
                style: TextStyle(color: textColor),  // White or black text depending on theme
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
