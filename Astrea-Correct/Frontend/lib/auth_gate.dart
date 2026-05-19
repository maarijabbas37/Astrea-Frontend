// File: lib/auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astrea_correct_app/main_shell.dart';
import 'package:astrea_correct_app/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is still waiting, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        // If a user is logged in (snapshot has data)
        if (snapshot.hasData) {
          return const MainShell();
        }
        // If no user is logged in
        return const LoginScreen();
      },
    );
  }
}
