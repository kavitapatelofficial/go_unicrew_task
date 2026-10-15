import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double fontSize;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.accent.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 14,
            color: AppTheme.accent,
          ),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFB45309), // Amber 700
            ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 3),
            Text(
              '($reviewCount)',
              style: TextStyle(
                fontSize: fontSize - 1,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
