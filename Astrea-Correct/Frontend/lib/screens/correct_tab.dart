import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:astrea_correct_app/api/grammar_api_service.dart';
import 'package:astrea_correct_app/theme.dart';
import 'package:astrea_correct_app/providers/theme_provider.dart';

class CorrectTab extends StatefulWidget {
  final bool isGuest;
  final Function(Map<String, dynamic>) onCorrectionAdded;

  const CorrectTab({
    Key? key,
    required this.isGuest,
    required this.onCorrectionAdded,
  }) : super(key: key);

  @override
  State<CorrectTab> createState() => _CorrectTabState();
}

class _CorrectTabState extends State<CorrectTab> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedLanguage = 'english';
  String _correctedText = '';
  bool _isLoading = false;

  final List<Map<String, String>> _languages = [
    {'code': 'english', 'label': 'English', 'flag': '🇬🇧'},
    {'code': 'french', 'label': 'French', 'flag': '🇫🇷'},
    {'code': 'spanish', 'label': 'Spanish', 'flag': '🇪🇸'},
  ];

  Future<void> _processText() async {
    if (_inputController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _correctedText = '';
    });

    try {
      final input = _inputController.text;
      final result = await GrammarApiService.correctText(input, _selectedLanguage);

      if (mounted) {
        setState(() => _correctedText = result);
        widget.onCorrectionAdded({
          'timestamp': DateTime.now(),
          'input': input,
          'output': result,
          'language': _selectedLanguage,
          'flag': _languages.firstWhere((l) => l['code'] == _selectedLanguage)['flag'],
        });
      }
    } catch (e) {
      if (mounted) setState(() => _correctedText = 'Connection error. Check your backend.');
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
          Text('Grammar Correction', style: AppTextStyles.headline1),
          const SizedBox(height: 8),
          Text('Ensure your writing is flawless and professional.', 
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
                      _buildHeader('INPUT TEXT', Icons.edit_note_rounded),
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Paste or type your text here...',
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLanguageDropdown(),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _processText,
                            icon: _isLoading 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.auto_awesome),
                            label: const Text('Correct Text'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Output Panel
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader('POLISHED VERSION', Icons.verified_rounded),
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
                            child: _correctedText.isEmpty 
                              ? Center(child: Text('Your results will appear here.', style: TextStyle(color: kTextSecondary.withOpacity(0.5))))
                              : SelectableText(_correctedText, style: AppTextStyles.bodyText),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_correctedText.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => Clipboard.setData(ClipboardData(text: _correctedText)),
                            icon: const Icon(Icons.copy_all_rounded, color: kPrimaryBrown),
                            label: const Text('Copy to Clipboard', style: TextStyle(color: kPrimaryBrown)),
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

  Widget _buildLanguageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryBrown),
          items: _languages.map((lang) {
            return DropdownMenuItem(
              value: lang['code'],
              child: Text('${lang['flag']} ${lang['label']}'),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedLanguage = val!),
        ),
      ),
    );
  }
}
