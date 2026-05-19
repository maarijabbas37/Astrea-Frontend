import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:astrea_correct_app/auth_gate.dart';
import 'package:astrea_correct_app/theme.dart';
import 'package:astrea_correct_app/providers/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const AstreaCorrectApp(),
    ),
  );
}

class AstreaCorrectApp extends StatelessWidget {
  const AstreaCorrectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astrea Correct',
      theme: buildBrownTheme(), // Applying the premium Brown Theme
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
