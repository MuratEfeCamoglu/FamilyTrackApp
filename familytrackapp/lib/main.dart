import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_decorations.dart';
import 'core/constants/app_spacing.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_text_styles.dart';
import 'core/di/injection.dart';
import 'core/services/firebase_service.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/app_bottom_nav.dart';

/// Uygulama giriş noktası.
///
/// Başlatma sırası (CLAUDE.md §Öncelik Sırası):
/// 1. Flutter binding
/// 2. SystemUI — durum çubuğu şeffaf, ikonlar koyu
/// 3. Türkçe tarih formatları
/// 4. Firebase (Firestore offline persistence dahil)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Dependency Injection kurulumu
  configureDependencies();

  // Durum çubuğu şeffaf, ikonlar koyu (pembe arka planla uyumlu)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light, // iOS
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // Yalnızca dikey yönlendirme (mobil UX)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Türkçe tarih formatları (intl)
  await initializeDateFormatting('tr_TR', null);

  // Firebase başlatma — offline persistence + server timestamp
  await FirebaseService.initialize();

  runApp(const FamilyMomentsApp());
}

/// Kök uygulama widget'ı.
///
/// `AppTheme.light` → MaterialApp'e bağlıdır.
/// Lokalizasyon: `tr_TR` (Türkçe)
class FamilyMomentsApp extends StatelessWidget {
  const FamilyMomentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ── Meta ──────────────────────────────────────────────
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // ── Tasarım Sistemi ───────────────────────────────────
      theme: AppTheme.light,

      // ── Lokalizasyon ──────────────────────────────────────
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],

      // ── Ana Shell ─────────────────────────────────────────
      home: const _MainShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Ana İskelet
// ─────────────────────────────────────────────────────────────────

/// 4 sekme arasında geçişi yöneten ana scaffold.
///
/// Sprint 1: Geçici `_PlaceholderPage` widget'larıyla doldurulmuş.
/// Sprint 2+: Gerçek feature sayfaları buraya bağlanacak.
class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  // TODO Sprint 2+: Gerçek page widget'larıyla değiştirilecek
  static const List<Widget> _pages = [
    _PlaceholderPage(
      label: AppStrings.navToday,
      icon: Icons.home_rounded,
      description: 'Seçili kişiyle gün sayacı\nve yaklaşan özel günler',
    ),
    _PlaceholderPage(
      label: AppStrings.navCalendar,
      icon: Icons.calendar_month_rounded,
      description: 'Tüm özel günlerin\ntakvim görünümü',
    ),
    _PlaceholderPage(
      label: AppStrings.navMoments,
      icon: Icons.auto_stories_rounded,
      description: 'Fotoğraflı anlar\nve zaman tüneli',
    ),
    _PlaceholderPage(
      label: AppStrings.navProfile,
      icon: Icons.people_rounded,
      description: 'Kişi listesi ve\nkişiye özel bilgiler',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Placeholder Sayfası — Sprint 1 iskelet görünümü
// ─────────────────────────────────────────────────────────────────

/// Gerçek feature sayfaları tamamlanana kadar kullanılan iskelet sayfa.
///
/// Tasarım sisteminin doğruluğunu görsel olarak test etmek için
/// AppColors, AppTextStyles ve AppDecorations token'larını kullanır.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.label,
    required this.icon,
    required this.description,
  });

  final String label;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Üst Banner ──────────────────────────────────
          SliverToBoxAdapter(
            child: _PageHeader(label: label, icon: icon),
          ),
          // ── İçerik Önizleme Kartları ─────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _DesignPreviewCard(description: description),
                const SizedBox(height: AppSpacing.md),
                _TokenShowcase(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero banner — AppDecorations.heroBanner + gradyan
class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topPadding + AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: AppDecorations.softGradientBackground,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.appName, style: AppTextStyles.label),
              Text(label, style: AppTextStyles.h1),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sayfa açıklamasını gösteren kart — AppDecorations.card
class _DesignPreviewCard extends StatelessWidget {
  const _DesignPreviewCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: AppDecorations.iconBackground(
              color: AppColors.surfaceLight,
              radius: AppSpacing.sm + 4,
            ),
            child: const Icon(
              Icons.construction_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Geliştirme Aşamasında', style: AppTextStyles.bodyBold),
                const SizedBox(height: AppSpacing.xs),
                Text(description, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tasarım token'larını görsel olarak sergileyen widget
class _TokenShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.cardLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tasarım Sistemi', style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.md),
          // Renk paleti
          const Row(
            children: [
              _ColorDot(color: AppColors.primary, label: 'Primary'),
              SizedBox(width: AppSpacing.sm),
              _ColorDot(color: AppColors.primaryDark, label: 'Dark'),
              SizedBox(width: AppSpacing.sm),
              _ColorDot(color: AppColors.primaryLight, label: 'Light'),
              SizedBox(width: AppSpacing.sm),
              _ColorDot(color: AppColors.textPrimary, label: 'Text'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Tipografi örnekleri
          Text('Nunito Başlık', style: AppTextStyles.h2),
          Text('DM Sans gövde metni örneği', style: AppTextStyles.body),
          Text('LABEL · SMALL CAPS', style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.md),
          // Düğme örneği
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.favorite_rounded, size: 18),
              label: const Text('Ana Eylem'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('İkincil Eylem'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Küçük renk çemberi etiketi
class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: AppDecorations.cardShadow,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
