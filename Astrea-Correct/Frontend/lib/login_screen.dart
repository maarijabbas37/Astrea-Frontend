import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/main_shell.dart';
import 'package:astrea_correct_app/signup_screen.dart';
import 'package:astrea_correct_app/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = ''; });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainShell()));
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Authentication failed.';
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainBg,
      body: Row(
        children: [
          // Left: Branding & Illustration Section
          Expanded(
            flex: 4,
            child: Container(
              color: kPrimaryBrown,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.network(
                        'https://www.transparenttextures.com/patterns/dark-leather.png',
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                  Center(
                    child: FadeInLeft(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120, height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 60),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'ASTREA CORRECT',
                            style: AppTextStyles.headline1.copyWith(color: Colors.white, letterSpacing: 4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'AI-Powered Linguistic Refinement',
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right: Login Form Section
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Center(
                child: SingleChildScrollView(
                  child: FadeInRight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Welcome Back', style: AppTextStyles.headline1),
                          const SizedBox(height: 8),
                          Text('Sign in to continue your writing journey.', style: TextStyle(color: kTextSecondary)),
                          const SizedBox(height: 48),
                          
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined, color: kPrimaryBrown),
                            ),
                            validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
                          ),
                          const SizedBox(height: 24),
                          
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: kPrimaryBrown),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: kPrimaryBrown),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
                          ),
                          
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?', style: TextStyle(color: kPrimaryBrown)),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Sign In Button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _signIn,
                            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
                            child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Sign In'),
                          ),
                          
                          if (_errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(_errorMessage, style: const TextStyle(color: kErrorRed, fontSize: 12)),
                          ],
                          
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?", style: TextStyle(color: kTextSecondary)),
                              TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                                child: const Text('Sign Up', style: TextStyle(color: kPrimaryBrown, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell(isGuest: true))),
                              child: Text('Continue as Guest', style: TextStyle(color: kTextSecondary.withOpacity(0.7))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
