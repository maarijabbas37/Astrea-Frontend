import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/login_screen.dart';
import 'package:astrea_correct_app/theme.dart';
import 'package:astrea_correct_app/screens/settings/account_settings_screen.dart';
import 'package:astrea_correct_app/screens/settings/notifications_screen.dart';
import 'package:astrea_correct_app/screens/settings/help_feedback_screen.dart';
import 'package:astrea_correct_app/screens/settings/about_screen.dart';

class ProfileTab extends StatelessWidget {
  final bool isGuest;
  final int historyCount;

  const ProfileTab({Key? key, required this.isGuest, required this.historyCount}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = isGuest ? 'Guest User' : (user?.displayName ?? 'Astrea User');
    final String email = isGuest ? 'Sign up to sync across devices' : (user?.email ?? '');
    final String initials = displayName.isEmpty ? 'A' : displayName[0].toUpperCase();
    final String level = historyCount > 50 ? 'Master' : historyCount > 20 ? 'Advanced' : historyCount > 10 ? 'Pro' : 'Starter';
    final double progress = (historyCount / 50).clamp(0.0, 1.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Profile', style: AppTextStyles.headline1),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: User Info Card
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kSecondaryBrown.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 120, height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryBrown,
                              boxShadow: [
                                BoxShadow(color: kPrimaryBrown.withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(initials, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          const SizedBox(height: 24),
                          Text(displayName, style: AppTextStyles.headline2),
                          const SizedBox(height: 8),
                          Text(email, style: TextStyle(color: kTextSecondary)),
                          const SizedBox(height: 32),
                          _buildStatRow('Writing Level', level, Icons.workspace_premium_rounded),
                          const SizedBox(height: 16),
                          _buildStatRow('Corrections', historyCount.toString(), Icons.verified_user_rounded),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _signOut(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kErrorRed,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(isGuest ? 'Log In / Sign Up' : 'Sign Out'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Right: Settings & Actions
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Settings', style: AppTextStyles.headline2.copyWith(fontSize: 18)),
                    const SizedBox(height: 16),
                    _buildSettingsCard(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: kCardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryBrown, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryBrown)),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kSecondaryBrown.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildSettingsItem(context, Icons.person_outline_rounded, 'Personal Information', 'Update your details', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingsScreen()))),
          const Divider(height: 1),
          _buildSettingsItem(context, Icons.notifications_none_rounded, 'Notifications', 'Manage alerts', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
          const Divider(height: 1),
          _buildSettingsItem(context, Icons.help_outline_rounded, 'Help & Support', 'Get assistance', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpFeedbackScreen()))),
          const Divider(height: 1),
          _buildSettingsItem(context, Icons.info_outline_rounded, 'About Astrea', 'Version & terms', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: kPrimaryBrown.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: kPrimaryBrown, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: kTextSecondary)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
