import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/theme.dart';
import 'package:astrea_correct_app/providers/theme_provider.dart';
import 'package:astrea_correct_app/screens/correct_tab.dart';
import 'package:astrea_correct_app/screens/paraphrase_tab.dart';
import 'package:astrea_correct_app/screens/translate_tab.dart';
import 'package:astrea_correct_app/screens/vocabulary_tab.dart';
import 'package:astrea_correct_app/screens/history_tab.dart';
import 'package:astrea_correct_app/screens/tips_tab.dart';
import 'package:astrea_correct_app/screens/profile_tab.dart';

class MainShell extends StatefulWidget {
  final bool isGuest;
  const MainShell({Key? key, this.isGuest = false}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _history = [];

  // All 7 logical tabs: 0-Correct, 1-Paraphrase, 2-Translate, 3-Vocabulary, 4-History, 5-Tips, 6-Profile
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      CorrectTab(
        isGuest: widget.isGuest,
        onCorrectionAdded: (item) {
          setState(() => _history.insert(0, item));
        },
      ),
      const ParaphraseTab(),
      const TranslateTab(),
      const VocabularyTab(),
      HistoryTab(history: _history),
      const TipsTab(),
      ProfileTab(isGuest: widget.isGuest, historyCount: _history.length),
    ];
  }

  void _showMoreMenu() {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDark;
    final bgColor = isDark ? kDarkCard : kLightCard;
    final textColor = isDark ? kDarkTextPrimary : kLightTextPrimary;
    final subtextColor = isDark ? kDarkTextSecondary : kLightTextSecondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: kAstreaPrimary.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: subtextColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildMoreItem(Icons.history_rounded, 'History', '${_history.length} corrections', 4, textColor, subtextColor),
            const SizedBox(height: 8),
            _buildMoreItem(Icons.lightbulb_outline_rounded, 'Writing Tips', 'Master your grammar', 5, textColor, subtextColor),
            const SizedBox(height: 8),
            _buildMoreItem(Icons.person_outline_rounded, 'Profile', 'Account & settings', 6, textColor, subtextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreItem(IconData icon, String title, String subtitle, int tabIndex, Color textColor, Color subtextColor) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pop(context);
          setState(() => _currentIndex = tabIndex);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kAstreaPrimary.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kAstreaPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: kAstreaPrimary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600, color: textColor)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.labelText.copyWith(color: subtextColor)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: subtextColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    
    return Scaffold(
      body: Row(
        children: [
          // Desktop/Web Sidebar
          Container(
            width: 260,
            color: kPrimaryBrown,
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ASTREA',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _buildSidebarItem(0, Icons.edit_note_rounded, 'Grammar Fix'),
                      _buildSidebarItem(1, Icons.history_edu_rounded, 'Paraphrase'),
                      _buildSidebarItem(2, Icons.translate_rounded, 'Translate'),
                      _buildSidebarItem(3, Icons.menu_book_rounded, 'Vocabulary'),
                      const Divider(color: Colors.white24, height: 40),
                      _buildSidebarItem(4, Icons.history_rounded, 'History'),
                      _buildSidebarItem(5, Icons.tips_and_updates_rounded, 'Writing Tips'),
                      _buildSidebarItem(6, Icons.person_outline_rounded, 'Profile'),
                    ],
                  ),
                ),
                // Theme Toggle at bottom
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  leading: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: Colors.white70,
                  ),
                  title: Text(
                    isDark ? 'Light Mode' : 'Dark Mode',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  onTap: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(
                  key: ValueKey<int>(_currentIndex),
                  child: _tabs[_currentIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _currentIndex = index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? kAccentTan : Colors.white70,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
