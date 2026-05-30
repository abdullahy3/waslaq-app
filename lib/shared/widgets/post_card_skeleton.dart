import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Shimmer.fromColors(
        baseColor: context.colors.surfaceVariant,
        highlightColor: context.colors.border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 80,
                  height: 12,
                  color: context.colors.surfaceVariant,
                ),
                SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 12,
                  color: context.colors.surfaceVariant,
                ),
              ],
            ),
            SizedBox(height: 12),
            
            // Title
            Container(
              width: double.infinity,
              height: 16,
              color: context.colors.surfaceVariant,
            ),
            SizedBox(height: 8),
            
            // Content
            Container(
              width: double.infinity,
              height: 12,
              color: context.colors.surfaceVariant,
            ),
            SizedBox(height: 4),
            Container(
              width: 200,
              height: 12,
              color: context.colors.surfaceVariant,
            ),
            SizedBox(height: 12),
            
            // Footer
            Row(
              children: [
                Container(
                  width: 40,
                  height: 14,
                  color: context.colors.surfaceVariant,
                ),
                SizedBox(width: 16),
                Container(
                  width: 30,
                  height: 14,
                  color: context.colors.surfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
