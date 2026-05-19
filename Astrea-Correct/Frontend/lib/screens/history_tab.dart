import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrea_correct_app/theme.dart';

class HistoryTab extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryTab({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Correction History', style: AppTextStyles.headline1),
                  const SizedBox(height: 8),
                  Text('Review your past linguistic refinements.', 
                       style: TextStyle(color: kTextSecondary)),
                ],
              ),
              if (history.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: kPrimaryBrown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${history.length} Corrections Saved', 
                       style: const TextStyle(color: kPrimaryBrown, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: history.isEmpty
                ? _buildEmptyState()
                : _buildHistoryGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: kPrimaryBrown.withOpacity(0.1)),
          const SizedBox(height: 24),
          Text('Your history is currently empty.', style: AppTextStyles.headline2),
          const SizedBox(height: 8),
          Text('Start using Astrea to see your work here.', style: TextStyle(color: kTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildHistoryGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 2.2,
      ),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return _buildHistoryCard(item);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final DateTime date = item['timestamp'];
    final String formattedDate = DateFormat('MMM d, y · h:mm a').format(date);
    
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
              Row(
                children: [
                  Text(item['flag'] ?? '🌐', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(formattedDate, style: GoogleFonts.inter(fontSize: 11, color: kTextSecondary, fontWeight: FontWeight.w500)),
                ],
              ),
              const Icon(Icons.open_in_new_rounded, size: 16, color: kPrimaryBrown),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item['input'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: kTextSecondary.withOpacity(0.6),
              fontSize: 13,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              item['output'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
