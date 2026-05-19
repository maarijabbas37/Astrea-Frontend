import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrea_correct_app/api/grammar_api_service.dart';
import 'package:astrea_correct_app/theme.dart';

class TranslateTab extends StatefulWidget {
  const TranslateTab({Key? key}) : super(key: key);

  @override
  State<TranslateTab> createState() => _TranslateTabState();
}

class _TranslateTabState extends State<TranslateTab> {
  final TextEditingController _inputController = TextEditingController();
  String _sourceLanguage = 'Auto-Detect';
  String _targetLanguage = 'Urdu';
  String _translatedText = '';
  bool _isLoading = false;

  final List<Map<String, String>> _languages = [
    {'code': 'auto', 'label': 'Auto-Detect', 'flag': '🌐'},
    {'code': 'en', 'label': 'English', 'flag': '🇬🇧'},
    {'code': 'fr', 'label': 'French', 'flag': '🇫🇷'},
    {'code': 'es', 'label': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'ar', 'label': 'Arabic', 'flag': '🇸🇦'},
    {'code': 'ur', 'label': 'Urdu', 'flag': '🇵🇰'},
  ];

  final List<Map<String, String>> _targetLanguages = [
    {'code': 'en', 'label': 'English', 'flag': '🇬🇧'},
    {'code': 'fr', 'label': 'French', 'flag': '🇫🇷'},
    {'code': 'es', 'label': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'ar', 'label': 'Arabic', 'flag': '🇸🇦'},
    {'code': 'ur', 'label': 'Urdu', 'flag': '🇵🇰'},
  ];

  Future<void> _processText() async {
    if (_inputController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _translatedText = '';
    });

    try {
      final input = _inputController.text;
      final src = _languages.firstWhere((l) => l['label'] == _sourceLanguage)['code']!;
      final tgt = _targetLanguages.firstWhere((l) => l['label'] == _targetLanguage)['code']!;
      
      final result = await GrammarApiService.translateText(input, src, tgt);

      if (mounted) {
        setState(() => _translatedText = result);
      }
    } catch (e) {
      if (mounted) setState(() => _translatedText = 'Translation failed. Ensure backend is running.');
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
          Text('Multilingual Translator', style: AppTextStyles.headline1),
          const SizedBox(height: 8),
          Text('Translate your text across multiple languages with AI precision.', 
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
                      _buildHeader('SOURCE TEXT', Icons.translate_rounded),
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Enter text to translate...',
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildLanguageDropdown(_sourceLanguage, _languages, (v) => setState(() => _sourceLanguage = v!)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.arrow_forward_rounded, color: kPrimaryBrown, size: 16),
                              ),
                              _buildLanguageDropdown(_targetLanguage, _targetLanguages, (v) => setState(() => _targetLanguage = v!)),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _processText,
                            icon: _isLoading 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.translate_rounded),
                            label: const Text('Translate'),
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
                      _buildHeader('TRANSLATED VERSION', Icons.g_translate_rounded),
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
                            child: _translatedText.isEmpty 
                              ? Center(child: Text('Translation will appear here.', style: TextStyle(color: kTextSecondary.withOpacity(0.5))))
                              : SelectableText(_translatedText, style: AppTextStyles.bodyText),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_translatedText.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => Clipboard.setData(ClipboardData(text: _translatedText)),
                            icon: const Icon(Icons.copy_all_rounded, color: kPrimaryBrown),
                            label: const Text('Copy Translation', style: TextStyle(color: kPrimaryBrown)),
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

  Widget _buildLanguageDropdown(String value, List<Map<String, String>> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryBrown),
          items: items.map((lang) {
            return DropdownMenuItem<String>(
              value: lang['label'],
              child: Text('${lang['flag']} ${lang['label']}'),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
