import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';

/// Kişi avatarı — profil fotoğrafı veya baş harf gösterir.
///
/// Kullanım:
/// ```dart
/// PersonAvatar(
///   name: 'Anne',
///   imageUrl: person.photoUrl,
///   radius: 32,
/// )
/// ```
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 28,
    this.onTap,
    this.showBorder = false,
  });

  /// Kişinin adı — fotoğraf yoksa baş harf hesaplanır.
  final String name;

  /// Firebase Storage veya harici fotoğraf URL'si.
  final String? imageUrl;

  /// Avatar yarıçapı (varsayılan: 28 px).
  final double radius;

  /// Tıklanabilir avatar için callback.
  final VoidCallback? onTap;

  /// Pembe kenarlık gösterilsin mi?
  final bool showBorder;

  /// İsmin baş harflerini üretir (maks 2 karakter).
  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: (_, __) => const _AvatarPlaceholder(),
                errorWidget: (_, __, ___) => _InitialsText(initials: _initials, radius: radius),
              ),
            )
          : _InitialsText(initials: _initials, radius: radius),
    );

    final Widget decorated = showBorder
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: AppSpacing.xs / 2,
              ),
            ),
            child: avatar,
          )
        : avatar;

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: decorated);
    }
    return decorated;
  }
}

/// Yüklenirken gösterilen shimmer placeholder.
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(color: AppColors.primaryLight);
  }
}

/// Baş harf metni.
class _InitialsText extends StatelessWidget {
  const _InitialsText({required this.initials, required this.radius});

  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Text(
      initials,
      style: AppTextStyles.h3.copyWith(
        color: AppColors.primary,
        fontSize: radius * 0.65,
      ),
    );
  }
}
