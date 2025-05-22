import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _fontSize = 16; // Default font size (within 12 to 24 range)
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  // Load saved font size from SharedPreferences
  void _loadFontSize() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // Ensure the value is within the range 12.0 to 24.0
      _fontSize = _prefs.getDouble('font_size') ?? 16; // Default to medium if no saved value
      if (_fontSize < 12.0) {
        _fontSize = 12.0; // Ensure minimum limit
      } else if (_fontSize > 24.0) {
        _fontSize = 24.0; // Ensure maximum limit
      }
    });
  }

  // Save selected font size to SharedPreferences
  void _saveFontSize(double fontSize) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setDouble('font_size', fontSize);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                colors: [Color(0xFF121212), Color(0xFF1F1F1F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : const LinearGradient(
                colors: [Color(0xFFFFC1E3), Color(0xFFE1BEE7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Toggle buttons
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.language),
                  color: theme.iconTheme.color,
                  onPressed: () {
                    final newLocale = isArabic
                        ? const Locale('en')
                        : const Locale('ar');
                    context.setLocale(newLocale);
                  },
                ),
              ],
            ),
          ),

          // Main card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.medical_services_rounded,
                        size: 72, color: theme.colorScheme.primary),
                    const SizedBox(height: 20),

                    // App title
                    Text(
                      'app_name'.tr(),
                      style: isArabic
                          ? GoogleFonts.tajawal(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      )
                          : GoogleFonts.poppins(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Tagline
                    Text(
                      'tagline'.tr(),
                      textAlign: TextAlign.center,
                      style: isArabic
                          ? GoogleFonts.tajawal(
                        fontSize: _fontSize - 2,
                        color: theme.textTheme.bodyMedium?.color,
                      )
                          : GoogleFonts.poppins(
                        fontSize: _fontSize - 2,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward_ios),
                      label: Text('get_started'.tr()),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 16),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Version
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "${'version'.tr()} 1.0.0",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ),
          ),

          // Font size slider
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Font Size',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Slider(
                    min: 16,
                    max: 32,
                    value: _fontSize,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                      _saveFontSize(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
