import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/theme.dart';
import 'package:astrea_correct_app/providers/theme_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _correctionAlerts = true;
  bool _tipOfTheDay = true;
  bool _weeklyReport = false;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final textColor = isDark ? kDarkTextPrimary : kLightTextPrimary;
    final subtextColor = isDark ? kDarkTextSecondary : kLightTextSecondary;
    final bgColor = isDark ? kDarkBg : kLightBg;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: kAstreaSecondary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('General', style: AppTextStyles.headline2.copyWith(color: textColor, fontSize: 18)),
                const SizedBox(height: 12),
                _buildToggle('Push Notifications', 'Receive alerts on your device', Icons.notifications_active_rounded, _pushEnabled, (v) => setState(() => _pushEnabled = v), isDark, textColor, subtextColor),
                const SizedBox(height: 10),
                _buildToggle('Email Notifications', 'Get updates in your inbox', Icons.email_outlined, _emailEnabled, (v) => setState(() => _emailEnabled = v), isDark, textColor, subtextColor),
              ],
            ),
          ),

          const SizedBox(height: 28),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Activity', style: AppTextStyles.headline2.copyWith(color: textColor, fontSize: 18)),
                const SizedBox(height: 12),
                _buildToggle('Correction Alerts', 'Notify when correction completes', Icons.check_circle_outline_rounded, _correctionAlerts, (v) => setState(() => _correctionAlerts = v), isDark, textColor, subtextColor),
                const SizedBox(height: 10),
                _buildToggle('Tip of the Day', 'Daily writing improvement tips', Icons.lightbulb_outline_rounded, _tipOfTheDay, (v) => setState(() => _tipOfTheDay = v), isDark, textColor, subtextColor),
                const SizedBox(height: 10),
                _buildToggle('Weekly Report', 'Summary of your writing stats', Icons.bar_chart_rounded, _weeklyReport, (v) => setState(() => _weeklyReport = v), isDark, textColor, subtextColor),
              ],
            ),
          ),

          const SizedBox(height: 28),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marketing', style: AppTextStyles.headline2.copyWith(color: textColor, fontSize: 18)),
                const SizedBox(height: 12),
                _buildToggle('Promotions & Updates', 'New features and special offers', Icons.campaign_rounded, _promotions, (v) => setState(() => _promotions = v), isDark, textColor, subtextColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged, bool isDark, Color textColor, Color subtextColor) {
    return Container(
      decoration: kGlassDecoration(radius: 14, isDark: isDark),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: kAstreaPrimary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kAstreaPrimary, size: 20),
        ),
        title: Text(title, style: AppTextStyles.bodyText.copyWith(color: textColor, fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: AppTextStyles.labelText.copyWith(color: subtextColor, fontSize: 11)),
        value: value,
        activeColor: kAstreaPrimary,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
