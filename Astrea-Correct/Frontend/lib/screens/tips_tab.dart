import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrea_correct_app/theme.dart';

class TipsTab extends StatefulWidget {
  const TipsTab({Key? key}) : super(key: key);

  @override
  State<TipsTab> createState() => _TipsTabState();
}

class _TipsTabState extends State<TipsTab> {
  String _activeCategory = 'All';

  final List<Map<String, String>> _categories = [
    {'label': 'All', 'icon': '🌟'},
    {'label': 'Punctuation', 'icon': '📍'},
    {'label': 'Grammar', 'icon': '📚'},
    {'label': 'Style', 'icon': '✍️'},
  ];

  final List<Map<String, String>> _tips = [
    {
      'title': 'Oxford Comma',
      'category': 'Punctuation',
      'desc': 'Use a comma before the last item in a list to avoid ambiguity.',
      'example': 'Red, white, and blue.',
    },
    {
      'title': 'They\'re vs. Their',
      'category': 'Grammar',
      'desc': '"They\'re" is they are. "Their" implies possession.',
      'example': 'Their dog is there, they\'re happy.',
    },
    {
      'title': 'Active Voice',
      'category': 'Style',
      'desc': 'Subjects should perform actions, not be acted upon.',
      'example': '"The chef cooked" vs "The meal was cooked".',
    },
    {
      'title': 'Semicolons',
      'category': 'Punctuation',
      'desc': 'Connect two related independent clauses.',
      'example': 'I have a big test; I must study tonight.',
    },
    {
      'title': 'Who vs. Whom',
      'category': 'Grammar',
      'desc': '"Who" is a subject; "Whom" is an object.',
      'example': 'Who saw him? To whom it may concern.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTips = _activeCategory == 'All'
        ? _tips
        : _tips.where((t) => t['category'] == _activeCategory).toList();

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Writing Excellence Tips', style: AppTextStyles.headline1),
          const SizedBox(height: 8),
          Text('Curated insights to master the art of written communication.', 
               style: TextStyle(color: kTextSecondary)),
          const SizedBox(height: 32),
          
          // Categories
          Row(
            children: _categories.map((cat) {
              final isSelected = _activeCategory == cat['label'];
              return GestureDetector(
                onTap: () => setState(() => _activeCategory = cat['label']!),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryBrown : kCardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(cat['icon']!),
                      const SizedBox(width: 8),
                      Text(
                        cat['label']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : kTextPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.8,
              ),
              itemCount: filteredTips.length,
              itemBuilder: (context, index) {
                final tip = filteredTips[index];
                return _buildTipCard(tip);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(Map<String, String> tip) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSecondaryBrown.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kAccentTan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tip['category']!.toUpperCase(),
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: kPrimaryBrown, letterSpacing: 1),
                ),
              ),
              const Icon(Icons.lightbulb_outline_rounded, color: kAccentTan, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(tip['title']!, style: AppTextStyles.headline2.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              tip['desc']!,
              style: TextStyle(color: kTextSecondary, fontSize: 14, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kCardBg.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology_outlined, size: 14, color: kPrimaryBrown),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip['example']!,
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: kTextPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
