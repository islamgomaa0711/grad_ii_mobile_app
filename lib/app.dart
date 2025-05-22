import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'theme_provider.dart';
import 'welcome_screen.dart';
import 'dashboard_screen.dart';

class PillDispenserApp extends StatelessWidget {
  const PillDispenserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isArabic = context.locale.languageCode == 'ar';

    final baseTextTheme = isArabic
        ? GoogleFonts.tajawalTextTheme()
        : GoogleFonts.poppinsTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pill Dispenser',
      themeMode: themeProvider.currentTheme,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
        cardColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.pinkAccent),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.pinkAccent,
        ),
        textTheme: baseTextTheme.apply(
          bodyColor: Colors.pinkAccent,
          displayColor: Colors.pinkAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.pinkAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pinkAccent),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
          secondary: Colors.purple,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        textTheme: baseTextTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyanAccent),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.cyanAccent,
          onPrimary: Colors.black,
          secondary: Colors.tealAccent,
        ),
      ),

      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      // Dynamically route based on authentication status
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const DashboardScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
