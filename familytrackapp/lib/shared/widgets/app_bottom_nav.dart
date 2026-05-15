import 'package:flutter/material.dart';
import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
import 'package:familytrackapp/core/constants/app_strings.dart';

/// Uygulama genelindeki alt navigasyon çubuğu.
///
/// CLAUDE.md §Ortak Widget'lar: Paylaşımlı widget'lar `shared/widgets/` altındadır.
/// Kullanım:
/// ```dart
/// Scaffold(
///   body: ...,
///   bottomNavigationBar: AppBottomNav(
///     currentIndex: _currentIndex,
///     onTap: (i) => setState(() => _currentIndex = i),
///   ),
/// )
/// ```
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Aktif sekme indeksi (0: Bugün, 1: Takvim, 2: Anlar, 3: Profil).
  final int currentIndex;

  /// Sekme değiştiğinde tetiklenir.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppDecorations.bottomNavShadow,
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: AppStrings.navToday,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month_rounded),
              label: AppStrings.navCalendar,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined),
              activeIcon: Icon(Icons.auto_stories_rounded),
              label: AppStrings.navMoments,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: AppStrings.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
