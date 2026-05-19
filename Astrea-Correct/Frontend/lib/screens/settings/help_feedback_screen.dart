import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/theme.dart';
import 'package:astrea_correct_app/providers/theme_provider.dart';

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _submitted = false;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'What is Astrea Correct?',
      'a': 'Astrea Correct is an AI-powered multilingual grammar correction and text refinement platform. It helps you write better in English, French, Spanish, Arabic, and Urdu.',
    },
    {
      'q': 'How does grammar correction work?',
      'a': 'Our AI model analyzes your text for grammar, spelling, punctuation, and style issues, then provides an improved version with corrections highlighted.',
    },
    {
      'q': 'Which languages are supported?',
      'a': 'Currently we support English, French, Spanish, Arabic, and Urdu. We are actively working on adding more languages.',
    },
    {
      'q': 'Is my data safe?',
      'a': 'Yes! Your text is processed securely and we do not store your corrections permanently. Your data privacy is our top priority.',
    },
    {
      'q': 'How do I use the Paraphrase feature?',
      'a': 'Navigate to the Paraphrase tab, enter your text, select a tone (Formal, Casual, Concise, Creative), and tap "Paraphrase with Astrea" to get a rewritten version.',
    },
    {
      'q': 'Can I use Astrea Correct offline?',
      'a': 'The grammar correction and translation features require an internet connection as they use our cloud-based AI. Tips and vocabulary features work with cached data.',
    },
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) return;
    // TODO: Send feedback to backend
    setState(() => _submitted = true);
    _feedbackController.clear();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _submitted = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final textColor = isDark ? kDarkTextPrimary : kLightTextPrimary;
    final subtextColor = isDark ? kDarkTextSecondary : kLightTextSecondary;
    final bgColor = isDark ? kDarkBg : kLightBg;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Help & Feedback'),
        backgroundColor: kAstreaSecondary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Feedback form
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send Feedback', style: AppTextStyles.headline2.copyWith(color: textColor, fontSize: 18)),
                const SizedBox(height: 6),
                Text('We\'d love to hear from you!', style: AppTextStyles.subtitle1.copyWith(color: subtextColor)),
                const SizedBox(height: 14),
                Container(
                  decoration: kGlassDecoration(radius: 14, isDark: isDark),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    style: AppTextStyles.bodyText.copyWith(color: textColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Tell us about your experience, bugs, or feature requests...',
                      hintStyle: AppTextStyles.labelText.copyWith(color: subtextColor.withOpacity(0.5)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _submitted
                    ? Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: kAstreaSuccess.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kAstreaSuccess.withOpacity(0.35)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.check_circle_rounded, color: kAstreaSuccess, size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: Text('Thank you! Your feedback has been submitted.', style: AppTextStyles.bodyText.copyWith(color: kAstreaSuccess, fontSize: 13))),
                        ]),
                      )
                    : Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: kButtonGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: kAstreaPrimary.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _submitFeedback,
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                          label: Text('Submit Feedback', style: AppTextStyles.buttonText.copyWith(fontSize: 14)),
                        ),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // FAQ section
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Frequently Asked Questions', style: AppTextStyles.headline2.copyWith(color: textColor, fontSize: 18)),
                const SizedBox(height: 14),
                ..._faqs.map((faq) => _buildFaqItem(faq, isDark, textColor, subtextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(Map<String, String> faq, bool isDark, Color textColor, Color subtextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: kGlassDecoration(radius: 14, isDark: isDark),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: kAstreaAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.help_outline_rounded, color: kAstreaAccent, size: 18),
          ),
          title: Text(faq['q']!, style: AppTextStyles.bodyText.copyWith(color: textColor, fontWeight: FontWeight.w600, fontSize: 14)),
          iconColor: subtextColor,
          collapsedIconColor: subtextColor,
          children: [
            Text(faq['a']!, style: AppTextStyles.bodyText.copyWith(color: subtextColor, fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
