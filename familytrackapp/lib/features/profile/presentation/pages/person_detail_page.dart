import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/core/services/firebase_service.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/presentation/cubit/person_detail_cubit.dart';
import 'package:familytrackapp/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:familytrackapp/features/profile/presentation/widgets/info_card_widget.dart';
import 'package:familytrackapp/shared/widgets/loading_skeleton.dart';

/// Kişi detay sayfası — bilgi kartları + ekleme bottom sheet.
class PersonDetailPage extends StatelessWidget {
  const PersonDetailPage({super.key, required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PersonDetailCubit>()
        ..loadDetails(
          userId: FirebaseService.currentUserId ?? '',
          person: person,
        ),
      child: _PersonDetailView(person: person),
    );
  }
}

class _PersonDetailView extends StatelessWidget {
  const _PersonDetailView({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<PersonDetailCubit, PersonDetailState>(
        listener: (context, state) {
          if (state is PersonDetailActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage)));
          }
          if (state is PersonDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade400,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PersonDetailLoading) {
            return const PageLoadingSkeleton(showHeroCard: true, itemCount: 4);
          }

          final details = _detailsFrom(state);
          return CustomScrollView(
            slivers: [
              _PersonSliverHeader(person: person),
              _DaysBanner(person: person),
              if (details.isEmpty)
                const SliverFillRemaining(child: _EmptyDetailView())
              else
                _InfoGrid(details: details),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl * 4),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _AddDetailFab(person: person),
    );
  }

  List<PersonDetail> _detailsFrom(PersonDetailState state) {
    if (state is PersonDetailLoaded) return state.details;
    if (state is PersonDetailActionSuccess) return state.details;
    return [];
  }
}

// ─────────────────────────────────────────────────────────
// Sliver Header
// ─────────────────────────────────────────────────────────

class _PersonSliverHeader extends StatelessWidget {
  const _PersonSliverHeader({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    final initials = person.name.isNotEmpty
        ? person.name.trim().split(' ').map((w) => w[0]).take(2).join()
        : '?';

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _confirmDeletePerson(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          person.name,
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
        background: Container(
          decoration: AppDecorations.softGradientBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials.toUpperCase(),
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${person.relationshipType.emoji} ${person.relationshipType.label}',
                  style: AppTextStyles.caption.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeletePerson(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kişiyi Sil'),
        content: Text('${person.name} ve bu kişiye ait tüm anlar kalıcı olarak silinecek. Emin misin?'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              final userId = FirebaseService.currentUserId ?? '';
              try {
                final profileCubit = context.read<ProfileCubit>();
                final success = await profileCubit.deletePerson(userId: userId, personId: person.id);
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Silme işlemi başarısız oldu: $e')),
                  );
                }
              }
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Gün sayacı banner
// ─────────────────────────────────────────────────────────

class _DaysBanner extends StatelessWidget {
  const _DaysBanner({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: AppDecorations.card,
        child: Row(
          children: [
            const Text('🗓️', style: TextStyle(fontSize: 28)),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Birlikte',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${person.daysTogether} gün',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Başlangıç',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${person.startDate.day.toString().padLeft(2, '0')}.${person.startDate.month.toString().padLeft(2, '0')}.${person.startDate.year}',
                  style: AppTextStyles.bodyBold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Bilgi kartları ızgarası
// ─────────────────────────────────────────────────────────

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.details});
  final List<PersonDetail> details;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate((context, i) {
          final detail = details[i];
          return InfoCardWidget(
            detail: detail,
            onDelete: () => context.read<PersonDetailCubit>().deleteDetail(
              userId: FirebaseService.currentUserId ?? '',
              detailId: detail.id,
            ),
          );
        }, childCount: details.length),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// FAB — Yeni bilgi ekle
// ─────────────────────────────────────────────────────────

class _AddDetailFab extends StatelessWidget {
  const _AddDetailFab({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'detail_fab',
      onPressed: () => _showAddDetailSheet(context),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Bilgi Ekle'),
    );
  }

  void _showAddDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PersonDetailCubit>(),
        child: const _AddDetailSheet(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Bilgi Ekleme Bottom Sheet
// ─────────────────────────────────────────────────────────

class _AddDetailSheet extends StatefulWidget {
  const _AddDetailSheet();

  @override
  State<_AddDetailSheet> createState() => _AddDetailSheetState();
}

class _AddDetailSheetState extends State<_AddDetailSheet> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  String _selectedIcon = '💬';
  bool _isSaving = false;

  static const _presetIcons = [
    '🌸',
    '☕',
    '🎵',
    '🍕',
    '🌙',
    '❤️',
    '🏆',
    '✈️',
    '📚',
    '🎨',
    '💊',
    '🌹',
    '⭐',
    '🐾',
    '🎭',
    '💼',
    '🎮',
    '💬',
  ];

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.lg),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tutma çubuğu
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Yeni Bilgi Ekle', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.lg),

            // İkon seçici
            Text('İkon', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _presetIcons.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) {
                  final icon = _presetIcons[i];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _selectedIcon == icon
                            ? AppColors.primaryLight
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        border: _selectedIcon == icon
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(icon, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Anahtar (key)
            Text('Bilgi Başlığı', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                hintText: 'Örn: Favori Çiçek, Kan Grubu',
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Değer (value)
            Text('Değer', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(hintText: 'Örn: Gül, A Rh+'),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Kaydet
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final key = _keyController.text.trim();
    final value = _valueController.text.trim();
    if (key.isEmpty || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }
    setState(() => _isSaving = true);
    final now = DateTime.now();
    final detail = PersonDetail(
      id: '',
      personId: '',
      key: key,
      value: value,
      icon: _selectedIcon,
      createdAt: now,
    );
    await context.read<PersonDetailCubit>().addDetail(
      userId: FirebaseService.currentUserId ?? '',
      detail: detail,
    );
    if (mounted) Navigator.pop(context);
  }
}

// ─────────────────────────────────────────────────────────
// Boş durum
// ─────────────────────────────────────────────────────────

class _EmptyDetailView extends StatelessWidget {
  const _EmptyDetailView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📝', style: TextStyle(fontSize: 56)),
            const SizedBox(height: AppSpacing.md),
            Text('Henüz bilgi yok', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Favori çiçeği, kan grubu, kahve tercihi...\nBilgi Ekle butonuna tıklayarak başlayın.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
