import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/main_shell.dart';
import 'package:astrea_correct_app/theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = ''; });

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (_nameController.text.trim().isNotEmpty) {
        await cred.user?.updateDisplayName(_nameController.text.trim());
      }
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainShell()));
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Registration failed.';
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
          // Left: Form Section
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Center(
                child: SingleChildScrollView(
                  child: FadeInLeft(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryBrown),
                          ),
                          const SizedBox(height: 24),
                          Text('Create Account', style: AppTextStyles.headline1),
                          const SizedBox(height: 8),
                          Text('Join the elite circle of professional writers.', style: TextStyle(color: kTextSecondary)),
                          const SizedBox(height: 48),
                          
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline_rounded, color: kPrimaryBrown),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 24),

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
                            validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                          ),
                          const SizedBox(height: 40),
                          
                          // Sign Up Button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _signUp,
                            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
                            child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Create Account'),
                          ),
                          
                          if (_errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(_errorMessage, style: const TextStyle(color: kErrorRed, fontSize: 12)),
                          ],
                          
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?", style: TextStyle(color: kTextSecondary)),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Sign In', style: TextStyle(color: kPrimaryBrown, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Right: Branding Section
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
                    child: FadeInRight(
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
                            child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 60),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'JOIN ASTREA',
                            style: AppTextStyles.headline1.copyWith(color: Colors.white, letterSpacing: 4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Unlock the full potential of AI writing.',
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
        ],
      ),
    );
  }
}
