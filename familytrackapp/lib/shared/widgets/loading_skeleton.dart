import 'package:flutter/material.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';

/// Basit iskelet kutusu.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 12,
    this.shape = BoxShape.rectangle,
  });

  final double width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.45),
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(radius),
      ),
    );
  }
}

/// Sayfa yuklenirken kullanilan genel iskelet.
class PageLoadingSkeleton extends StatelessWidget {
  const PageLoadingSkeleton({
    super.key,
    this.showHeroCard = true,
    this.itemCount = 4,
  });

  final bool showHeroCard;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              topPadding + AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: const Row(
              children: [
                SkeletonBox(width: 48, height: 48, shape: BoxShape.circle),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 120, height: 12, radius: 8),
                      SizedBox(height: AppSpacing.sm),
                      SkeletonBox(width: 160, height: 26, radius: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showHeroCard)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SkeletonBox(height: 172, radius: 18),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList.separated(
            itemBuilder: (_, __) => const SkeletonBox(height: 88, radius: 14),
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemCount: itemCount,
          ),
        ),
      ],
    );
  }
}
