import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';

/// Kişi listesi ızgara kartı.
///
/// Üstte büyük yuvarlak avatar, altta isim ve ilişki rozeti gösterir.
class PersonCard extends StatelessWidget {
  const PersonCard({
    super.key,
    required this.person,
    required this.onTap,
    this.onLongPress,
  });

  final Person person;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: AppDecorations.card,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Avatar ───────────────────────────────────
            _PersonAvatar(person: person),
            const SizedBox(height: AppSpacing.sm),

            // ── İsim ─────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                person.name,
                style: AppTextStyles.bodyBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // ── İlişki rozeti ─────────────────────────────
            _RelationshipBadge(type: person.relationshipType),
            const SizedBox(height: AppSpacing.xs),

            // ── Gün sayacı ────────────────────────────────
            Text(
              '${person.daysTogether} gün',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────

class _PersonAvatar extends StatelessWidget {
  const _PersonAvatar({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final initials = person.name.isNotEmpty
        ? person.name.trim().split(' ').map((w) => w[0]).take(2).join()
        : '?';

    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: person.profileImageUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: person.profileImageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _AvatarInitials(initials: initials),
                errorWidget: (_, __, ___) =>
                    _AvatarInitials(initials: initials),
              ),
            )
          : _AvatarInitials(initials: initials),
    );
  }
}

class _AvatarInitials extends StatelessWidget {
  const _AvatarInitials({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials.toUpperCase(),
        style: AppTextStyles.h2.copyWith(
          color: AppColors.primary,
          fontSize: 22,
        ),
      ),
    );
  }
}

class _RelationshipBadge extends StatelessWidget {
  const _RelationshipBadge({required this.type});

  final RelationshipType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSpacing.xs + 2),
      ),
      child: Text(
        '${type.emoji} ${type.label}',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
