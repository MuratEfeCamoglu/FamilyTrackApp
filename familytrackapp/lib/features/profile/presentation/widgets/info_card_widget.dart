import 'package:flutter/material.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';

/// PersonDetail bilgi kartı — key + value + icon gösterir.
///
/// Uzun basılınca silme onayı açılır.
class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    super.key,
    required this.detail,
    this.onDelete,
  });

  final PersonDetail detail;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete != null
          ? () => _showDeleteDialog(context)
          : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: AppDecorations.cardLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── İkon + silme butonu ───────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  detail.icon ?? '💬',
                  style: const TextStyle(fontSize: 24),
                ),
                if (onDelete != null)
                  GestureDetector(
                    onTap: () => _showDeleteDialog(context),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // ── Anahtar (key) ─────────────────────────────
            Text(
              detail.key,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs / 2),

            // ── Değer (value) ─────────────────────────────
            Text(
              detail.value,
              style: AppTextStyles.bodyBold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bilgiyi sil'),
        content: Text('"${detail.key}" bilgisini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Sil',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete?.call();
  }
}
