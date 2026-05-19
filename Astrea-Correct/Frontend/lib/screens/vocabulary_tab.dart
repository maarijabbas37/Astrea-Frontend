import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrea_correct_app/api/grammar_api_service.dart';
import 'package:astrea_correct_app/theme.dart';

class VocabularyTab extends StatefulWidget {
  const VocabularyTab({Key? key}) : super(key: key);

  @override
  State<VocabularyTab> createState() => _VocabularyTabState();
}

class _VocabularyTabState extends State<VocabularyTab> {
  final TextEditingController _inputController = TextEditingController();
  String _enhancedText = '';
  bool _isLoading = false;

  Future<void> _processText() async {
    if (_inputController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _enhancedText = '';
    });

    try {
      final input = _inputController.text;
      final result = await GrammarApiService.enhanceVocabulary(input);

      if (mounted) {
        setState(() => _enhancedText = result);
      }
    } catch (e) {
      if (mounted) setState(() => _enhancedText = 'Enhancement failed. Check your connection.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vocabulary Enhancer', style: AppTextStyles.headline1),
          const SizedBox(height: 8),
          Text('Upgrade your wording with more sophisticated and impactful vocabulary.', 
               style: TextStyle(color: kTextSecondary)),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input Panel
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader('SIMPLE TEXT', Icons.auto_stories_rounded),
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Type a sentence to enhance its vocabulary...',
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _processText,
                          icon: _isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.upgrade_rounded),
                          label: const Text('Enhance Vocabulary'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Output Panel
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader('ENHANCED VERSION', Icons.auto_awesome_rounded),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kSecondaryBrown.withOpacity(0.2)),
                          ),
                          child: SingleChildScrollView(
                            child: _enhancedText.isEmpty 
                              ? Center(child: Text('Your sophisticated text will appear here.', style: TextStyle(color: kTextSecondary.withOpacity(0.5))))
                              : SelectableText(_enhancedText, style: AppTextStyles.bodyText),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_enhancedText.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: kSuccessGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Vocabulary Upgraded! ✨', style: TextStyle(color: kSuccessGreen, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kPrimaryBrown),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: kPrimaryBrown)),
        ],
      ),
    );
  }
}
