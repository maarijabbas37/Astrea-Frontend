import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrea_correct_app/api/grammar_api_service.dart';
import 'package:astrea_correct_app/theme.dart';

class ParaphraseTab extends StatefulWidget {
  const ParaphraseTab({Key? key}) : super(key: key);

  @override
  State<ParaphraseTab> createState() => _ParaphraseTabState();
}

class _ParaphraseTabState extends State<ParaphraseTab> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedTone = 'Formal';
  String _paraphrasedText = '';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _tones = [
    {'label': 'Formal', 'icon': Icons.business_center_rounded},
    {'label': 'Casual', 'icon': Icons.emoji_emotions_rounded},
    {'label': 'Concise', 'icon': Icons.short_text_rounded},
    {'label': 'Creative', 'icon': Icons.palette_rounded},
  ];

  Future<void> _processText() async {
    if (_inputController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _paraphrasedText = '';
    });

    try {
      final input = _inputController.text;
      // In our backend, tone can be passed as a prefix or parameter. 
      // For now, we'll use the /paraphrase endpoint.
      final result = await GrammarApiService.paraphraseText(input, _selectedTone.toLowerCase());

      if (mounted) {
        setState(() => _paraphrasedText = result);
      }
    } catch (e) {
      if (mounted) setState(() => _paraphrasedText = 'Failed to paraphrase. Check backend service.');
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
          Text('AI Paraphraser', style: AppTextStyles.headline1),
          const SizedBox(height: 8),
          Text('Rewrite your content to suit different styles and contexts.', 
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
                      _buildHeader('ORIGINAL TEXT', Icons.text_fields_rounded),
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Type something to rewrite...',
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildToneSelector(),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _processText,
                            icon: _isLoading 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.autorenew_rounded),
                            label: const Text('Paraphrase'),
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
                      _buildHeader('PARAPHRASED RESULT', Icons.auto_awesome_rounded),
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
                            child: _paraphrasedText.isEmpty 
                              ? Center(child: Text('Your rewritten text will appear here.', style: TextStyle(color: kTextSecondary.withOpacity(0.5))))
                              : SelectableText(_paraphrasedText, style: AppTextStyles.bodyText),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_paraphrasedText.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => Clipboard.setData(ClipboardData(text: _paraphrasedText)),
                            icon: const Icon(Icons.copy_all_rounded, color: kPrimaryBrown),
                            label: const Text('Copy Result', style: TextStyle(color: kPrimaryBrown)),
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

  Widget _buildToneSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTone,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryBrown),
          items: _tones.map((tone) {
            return DropdownMenuItem<String>(
              value: tone['label'],
              child: Row(
                children: [
                  Icon(tone['icon'] as IconData, size: 16, color: kPrimaryBrown),
                  const SizedBox(width: 8),
                  Text(tone['label'] as String),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedTone = val!),
        ),
      ),
    );
  }
}
