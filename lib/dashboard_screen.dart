import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'theme_provider.dart';
import 'medication_schedule_screen.dart';
import 'monitoring_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'welcome_screen.dart'; // or LoginScreen if you prefer

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final isArabic = context.locale.languageCode == 'ar';
    final font = isArabic ? GoogleFonts.tajawal() : GoogleFonts.poppins();

    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr()),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr(),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()), // or LoginScreen()
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'welcome_back'.tr() + ', John!',
              style: font.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleLarge?.color ?? theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'what_do_today'.tr(),
              style: TextStyle(color: theme.textTheme.bodyMedium?.color ?? theme.textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: 20),
            _buildLiveClock(theme, isDark),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: const EdgeInsets.only(top: 40),
                children: [
                  _buildDashboardCard(context, 'medication_schedule'.tr(), Icons.calendar_today, Colors.pinkAccent, const MedicationScheduleScreen()),
                  _buildDashboardCard(context, 'monitoring'.tr(), Icons.monitor_heart, Colors.deepPurple, const MonitoringScreen()),
                  _buildDashboardCard(context, 'notifications'.tr(), Icons.notifications_active, Colors.orange, const NotificationScreen()),
                  _buildDashboardCard(context, 'profile'.tr(), Icons.person, Colors.teal, const ProfileScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveClock(ThemeData theme, bool isDark) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (count) => DateTime.now()),
      builder: (context, snapshot) {
        final time = snapshot.hasData ? snapshot.data! : DateTime.now();
        final formattedTime = DateFormat.jm().format(time);

        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? theme.primaryColor : theme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Text(
            formattedTime,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? theme.textTheme.bodyLarge?.color : Colors.black,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    final theme = Theme.of(context);
    final isArabic = context.locale.languageCode == 'ar';
    final font = isArabic ? GoogleFonts.tajawal() : GoogleFonts.poppins();

    return Material(
      color: theme.cardColor,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: font.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color ?? theme.textTheme.bodyLarge?.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

