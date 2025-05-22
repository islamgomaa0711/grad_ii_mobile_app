import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import 'dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("verification_email_sent".tr())),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print("SIGNUP ERROR: ${e.code} - ${e.message}");
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'email_already_used'.tr();
          break;
        case 'invalid-email':
          message = 'invalid_email'.tr();
          break;
        case 'weak-password':
          message = 'weak_password'.tr();
          break;
        default:
          message = e.message ?? 'signup_failed'.tr();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _continueAsGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      print("GUEST SIGN-IN ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("guest_login_failed".tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.locale.languageCode == 'ar';
    final font = isArabic ? GoogleFonts.tajawal() : GoogleFonts.poppins();

    return Scaffold(
      appBar: AppBar(title: Text('sign_up_title'.tr())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('create_account'.tr(), style: font.copyWith(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(controller: _fullNameController, decoration: InputDecoration(labelText: 'full_name'.tr(), prefixIcon: const Icon(Icons.person))),
                const SizedBox(height: 20),
                TextField(controller: _emailController, decoration: InputDecoration(labelText: 'email'.tr(), prefixIcon: const Icon(Icons.email))),
                const SizedBox(height: 20),
                TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'password'.tr(), prefixIcon: const Icon(Icons.lock))),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading ? const CircularProgressIndicator() : Text('sign_up'.tr()),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: Text('already_have_account'.tr(), style: font.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _continueAsGuest,
                  child: Text('continue_as_guest'.tr(), style: font.copyWith(fontWeight: FontWeight.w600, fontSize: 14, color: theme.colorScheme.secondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
