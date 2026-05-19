import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/theme.dart';
import 'package:astrea_correct_app/providers/theme_provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isSaving = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() { _isSaving = true; _statusMessage = ''; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (_nameController.text.trim() != (user.displayName ?? '')) {
          await user.updateDisplayName(_nameController.text.trim());
        }
      }
      setState(() => _statusMessage = 'Profile updated successfully!');
    } catch (e) {
      setState(() => _statusMessage = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text.trim().length < 6) {
      setState(() => _statusMessage = 'Password must be at least 6 characters.');
      return;
    }
    setState(() { _isSaving = true; _statusMessage = ''; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Re-authenticate first
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(_newPasswordController.text.trim());
        setState(() => _statusMessage = 'Password changed successfully!');
        _currentPasswordController.clear();
        _newPasswordController.clear();
      }
    } catch (e) {
      setState(() => _statusMessage = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;
    final textColor = isDark ? kDarkTextPrimary : kLightTextPrimary;
    final subtextColor = isDark ? kDarkTextSecondary : kLightTextSecondary;
    final bgColor = isDark ? kDarkBg : kLightBg;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: kAstreaSecondary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Theme toggle
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: kGlassDecoration(radius: 16, isDark: isDark),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: kAstreaPrimary, size: 22),
                    const SizedBox(width: 12),
                    Text('Dark Mode', style: AppTextStyles.bodyText.copyWith(color: textColor, fontWeight: FontWeight.w600)),
                  ]),
                  Switch(
                    value: isDark,
                    activeColor: kAstreaPrimary,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Profile info section
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile Information', style: AppTextStyles.headline2.copyWith(color: textColor, fontSize: 18)),
                const SizedBox(height: 12),
                _buildField('Display Name', _nameController, Icons.person_outline_rounded, isDark, textColor, subtextColor),
                const SizedBox(height: 12),
                _buildField('Email', _emailController, Icons.email_outlined, isDark, textColor, subtextColor, enabled: false),
                const SizedBox(height: 16),
                _buildActionButton('Save Profile', _isSaving ? null : _saveProfile, _isSaving),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Password section
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Change Password', style: AppTextStyles.headline2.copyWith(color: textColor, fontSize: 18)),
                const SizedBox(height: 12),
                _buildField('Current Password', _currentPasswordController, Icons.lock_outline, isDark, textColor, subtextColor, obscure: true),
                const SizedBox(height: 12),
                _buildField('New Password', _newPasswordController, Icons.lock_reset_rounded, isDark, textColor, subtextColor, obscure: true),
                const SizedBox(height: 16),
                _buildActionButton('Change Password', _isSaving ? null : _changePassword, _isSaving),
              ],
            ),
          ),

          // Status message
          if (_statusMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _statusMessage.startsWith('Error')
                      ? kAstreaError.withOpacity(0.1)
                      : kAstreaSuccess.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _statusMessage.startsWith('Error')
                        ? kAstreaError.withOpacity(0.4)
                        : kAstreaSuccess.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  _statusMessage,
                  style: AppTextStyles.bodyText.copyWith(
                    color: _statusMessage.startsWith('Error') ? kAstreaError : kAstreaSuccess,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, bool isDark, Color textColor, Color subtextColor,
      {bool obscure = false, bool enabled = true}) {
    return Container(
      decoration: kGlassDecoration(radius: 12, isDark: isDark),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        enabled: enabled,
        style: AppTextStyles.bodyText.copyWith(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.labelText.copyWith(color: subtextColor),
          prefixIcon: Icon(icon, color: kAstreaPrimary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback? onPressed, bool isLoading) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: kButtonGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: kAstreaPrimary.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, style: AppTextStyles.buttonText.copyWith(fontSize: 14)),
      ),
    );
  }
}
