import 'package:flutter/material.dart';
import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';

/// Uygulamanın özelleştirilmiş AppBar'ı.
///
/// Standart `AppBar`'ın yerini alır; arka plan pembe gradyanı destekler.
/// Kullanım:
/// ```dart
/// Scaffold(
///   appBar: FamilyAppBar(title: 'Bugün'),
/// )
/// ```
class FamilyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FamilyAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.subtitle,
    this.showGradient = false,
  });

  /// Sayfa başlığı.
  final String title;

  /// Sağdaki aksiyon widget'ları.
  final List<Widget>? actions;

  /// Sol taraftaki widget (geri butonu vb.).
  final Widget? leading;

  /// İsteğe bağlı alt başlık.
  final String? subtitle;

  /// Gradyan arka plan gösterilsin mi?
  final bool showGradient;

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 72 : 56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showGradient
          ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.surface, AppColors.background],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )
          : const BoxDecoration(color: AppColors.surface),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h2),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
