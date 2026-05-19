import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrea_correct_app/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Astrea'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          // App logo + name section
          Center(
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
                  child: const Icon(Icons.auto_fix_high_rounded, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 24),
                Text('Astrea Correct', style: AppTextStyles.headline1),
                const SizedBox(height: 8),
                Text('AI-Powered Multilingual Text Refinement',
                    style: TextStyle(color: kTextSecondary, fontSize: 16),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // About the Project
          _buildSectionHeader('The Project'),
          _buildInfoCard([
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Astrea Correct is a premium AI-driven linguistic refinement platform designed to elevate written communication. '
                'Developed as a state-of-the-art Final Year Project, it integrates advanced natural language processing models '
                'to provide real-time grammar correction, paraphrasing, vocabulary enhancement, and multilingual translation.\n\n'
                'Our mission is to empower writers globally by providing professional-grade editing tools in a sleek, productive environment.',
                style: AppTextStyles.bodyText.copyWith(color: kTextSecondary, height: 1.8, fontSize: 14),
              ),
            ),
          ]),
          const SizedBox(height: 32),

          // Features
          _buildSectionHeader('Core Capabilities'),
          _buildInfoCard([
            _buildFeatureItem(Icons.spellcheck_rounded, 'Grammar Correction', 'Deep contextual analysis for error-free writing.'),
            const Divider(height: 1, indent: 64),
            _buildFeatureItem(Icons.history_edu_rounded, 'AI Paraphraser', 'Rewrite content in multiple tones and styles.'),
            const Divider(height: 1, indent: 64),
            _buildFeatureItem(Icons.upgrade_rounded, 'Vocabulary Upgrader', 'Replace simple words with sophisticated alternatives.'),
            const Divider(height: 1, indent: 64),
            _buildFeatureItem(Icons.g_translate_rounded, 'Multilingual Translator', 'Accurate translation with dedicated Urdu support.'),
          ]),
          const SizedBox(height: 32),

          // Tech Stack
          _buildSectionHeader('Technology Stack'),
          _buildInfoCard([
            Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTechChip('Flutter & Dart'),
                  _buildTechChip('Flask Backend'),
                  _buildTechChip('PyTorch / T5 Transformers'),
                  _buildTechChip('Firebase Auth'),
                  _buildTechChip('RESTful API'),
                  _buildTechChip('Ngrok GPU Tunneling'),
                ],
              ),
            ),
          ]),

          const SizedBox(height: 48),
          Center(
            child: Column(
              children: [
                const Text('Version 1.0.0 (Production Build)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                Text('© 2026 Astrea FYP Team. All rights reserved.',
                    style: TextStyle(color: kTextSecondary.withOpacity(0.6), fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: AppTextStyles.headline2.copyWith(fontSize: 18, color: kPrimaryBrown)),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kSecondaryBrown.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: kPrimaryBrown.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: kPrimaryBrown, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: kTextSecondary)),
    );
  }

  Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(label, style: const TextStyle(color: kPrimaryBrown, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }
}
