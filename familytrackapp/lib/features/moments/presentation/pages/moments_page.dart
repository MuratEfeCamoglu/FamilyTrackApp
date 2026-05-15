import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_strings.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/core/services/firebase_service.dart';
import 'package:familytrackapp/features/moments/domain/entities/moment_entity.dart';
import 'package:familytrackapp/features/moments/presentation/cubit/moments_cubit.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/shared/widgets/loading_skeleton.dart';

class MomentsPage extends StatelessWidget {
  const MomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.I<MomentsCubit>()
            ..loadMoments(FirebaseService.currentUserId ?? ''),
      child: const _MomentsView(),
    );
  }
}

class _MomentsView extends StatelessWidget {
  const _MomentsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<MomentsCubit, MomentsState>(
        listener: (context, state) {
          if (state is MomentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade400,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MomentsLoading || state is MomentsInitial) {
            return const PageLoadingSkeleton(showHeroCard: false, itemCount: 6);
          }
          if (state is MomentsLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _MomentsHeader()),
                if (state.moments.isEmpty)
                  const SliverFillRemaining(child: _EmptyView())
                else
                  _TimelineList(moments: state.moments),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xl * 4),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: BlocBuilder<MomentsCubit, MomentsState>(
        builder: (context, state) {
          if (state is! MomentsLoaded || state.persons.isEmpty) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            heroTag: 'moments_fab',
            onPressed: () => _showAddSheet(context, state.persons),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text(AppStrings.momentsAddFab),
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context, List<Person> persons) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<MomentsCubit>(),
        child: _AddMomentSheet(persons: persons),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────

class _MomentsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        top + AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      decoration: AppDecorations.softGradientBackground,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.appName, style: AppTextStyles.label),
              Text(AppStrings.navMoments, style: AppTextStyles.h1),
            ],
          ),
          const Spacer(),
          BlocBuilder<MomentsCubit, MomentsState>(
            builder: (context, state) {
              final count = state is MomentsLoaded ? state.moments.length : 0;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppSpacing.sm + 4),
                ),
                child: Text(
                  '$count ${AppStrings.momentsCountSuffix}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Timeline List
// ─────────────────────────────────────────────────────────

const _trMonthsShort = [
  '',
  'Oca',
  'Şub',
  'Mar',
  'Nis',
  'May',
  'Haz',
  'Tem',
  'Ağu',
  'Eyl',
  'Eki',
  'Kas',
  'Ara',
];

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.moments});
  final List<Moment> moments;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => _TimelineItem(
            moment: moments[i],
            isFirst: i == 0,
            isLast: i == moments.length - 1,
          ),
          childCount: moments.length,
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.moment,
    required this.isFirst,
    required this.isLast,
  });

  final Moment moment;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tarih sütunu ──────────────────────────────
          SizedBox(
            width: 52,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Column(
                children: [
                  Text(
                    moment.date.day.toString(),
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontSize: 22,
                      height: 1,
                    ),
                  ),
                  Text(
                    _trMonthsShort[moment.date.month],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Timeline sütunu ───────────────────────────
          SizedBox(
            width: 36,
            child: Column(
              children: [
                // Üst çizgi
                Container(
                  width: 2,
                  height: isFirst ? 24 : 24,
                  color: isFirst ? Colors.transparent : AppColors.primaryLight,
                ),
                // Nokta
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                // Alt çizgi
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),

          // ── Kart ─────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _MomentCard(moment: moment),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Moment Kartları
// ─────────────────────────────────────────────────────────

class _MomentCard extends StatelessWidget {
  const _MomentCard({required this.moment});
  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _confirmDelete(context),
      child: switch (moment.type) {
        MomentType.milestone => _BadgeCard(moment: moment),
        MomentType.photo || MomentType.memory => _PhotoCard(moment: moment),
        _ => _StandardCard(moment: moment),
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Anı sil'),
        content: Text('"${moment.title}" anısını silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Sil', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<MomentsCubit>().deleteMoment(
        userId: FirebaseService.currentUserId ?? '',
        momentId: moment.id,
        imageUrl: moment.imageUrl,
      );
    }
  }
}

// ROZET KAZANILDI kartı
class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.moment});
  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppDecorations.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(moment.type.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'ROZET KAZANILDI',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (moment.badgeName != null) ...[
            Text(
              moment.badgeName!,
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            moment.title,
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
          if (moment.description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              moment.description!,
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }
}

// FOTOĞRAFLI AN kartı
class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.moment});
  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.md),
            ),
            child: moment.hasImage
                ? Image.network(
                    moment.imageUrl!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _PhotoFallback(moment: moment),
                  )
                : _PhotoFallback(moment: moment),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.momentsNiceMoment,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(moment.title, style: AppTextStyles.bodyBold),
                if (moment.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    moment.description!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback({required this.moment});

  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      color: AppColors.primaryLight,
      child: Center(
        child: Text(moment.type.emoji, style: const TextStyle(fontSize: 52)),
      ),
    );
  }
}

class _StandardCard extends StatelessWidget {
  const _StandardCard({required this.moment});
  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Center(
              child: Text(
                moment.type.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moment.type.label.toUpperCase(),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(moment.title, style: AppTextStyles.bodyBold),
                if (moment.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    moment.description!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// An Ekleme Bottom Sheet
// ─────────────────────────────────────────────────────────

class _AddMomentSheet extends StatefulWidget {
  const _AddMomentSheet({required this.persons});
  final List<Person> persons;

  @override
  State<_AddMomentSheet> createState() => _AddMomentSheetState();
}

class _AddMomentSheetState extends State<_AddMomentSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _badgeController = TextEditingController();

  late Person _selectedPerson;
  MomentType _selectedType = MomentType.celebration;
  DateTime _date = DateTime.now();
  bool _isSaving = false;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _selectedPerson = widget.persons.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _badgeController.dispose();
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
            Text(AppStrings.momentsAddNew, style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.md),

            Text(AppStrings.momentsPersonLabel, style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.persons.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) {
                  final p = widget.persons[i];
                  final selected = p.id == _selectedPerson.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPerson = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppSpacing.sm + 4),
                      ),
                      child: Text(
                        p.name,
                        style: AppTextStyles.caption.copyWith(
                          color: selected
                              ? Colors.white
                              : AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text(AppStrings.momentsTypeLabel, style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MomentType.values.map((t) {
                final sel = t == _selectedType;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.sm + 4),
                      border: Border.all(
                        color: sel ? AppColors.primary : AppColors.primaryLight,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '${t.emoji} ${t.label}',
                      style: AppTextStyles.caption.copyWith(
                        color: sel ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            Text(AppStrings.momentsTitleLabel, style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: AppStrings.momentsTitleHint,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            if (_selectedType == MomentType.milestone) ...[
              Text(AppStrings.momentsBadgeLabel, style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _badgeController,
                decoration: const InputDecoration(
                  hintText: AppStrings.momentsBadgeHint,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            Text(
              AppStrings.momentsDescriptionLabel,
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: AppStrings.momentsDescriptionHint,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text(AppStrings.momentsPhotoLabel, style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  border: Border.all(color: AppColors.primaryLight, width: 1.5),
                ),
                child: _selectedImagePath == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo_rounded,
                            color: AppColors.primary,
                            size: 30,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppStrings.momentsPhotoSelect,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.sm - 1),
                        child: Image.file(
                          File(_selectedImagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            if (_selectedImagePath != null) ...[
              const SizedBox(height: AppSpacing.xs),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text(AppStrings.momentsPhotoChange),
              ),
            ],
            const SizedBox(height: AppSpacing.md),

            Text(AppStrings.momentsDateLabel, style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  locale: const Locale('tr', 'TR'),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  border: Border.all(color: AppColors.primaryLight, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${_date.day.toString().padLeft(2, '0')}.${_date.month.toString().padLeft(2, '0')}.${_date.year}',
                      style: AppTextStyles.body,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

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
                    : const Text(AppStrings.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.errorMomentTitleRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);
    final moment = Moment(
      id: '',
      personId: _selectedPerson.id,
      title: title,
      type: _selectedType,
      date: _date,
      imageUrl: _selectedImagePath,
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      badgeName: _badgeController.text.trim().isEmpty
          ? null
          : _badgeController.text.trim(),
      createdAt: DateTime.now(),
    );

    final success = await context.read<MomentsCubit>().addMoment(
      userId: FirebaseService.currentUserId ?? '',
      moment: moment,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final selected = await picker.pickImage(source: ImageSource.gallery);
    if (selected == null) return;

    final tempPath =
        '${Directory.systemTemp.path}/moment_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressed = await FlutterImageCompress.compressAndGetFile(
      selected.path,
      tempPath,
      quality: 78,
      minWidth: 1440,
      minHeight: 1440,
      format: CompressFormat.jpeg,
    );

    final resolvedPath = compressed?.path ?? selected.path;
    final bytes = await File(resolvedPath).readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.errorPhotoSize)));
      return;
    }

    if (!mounted) return;
    setState(() => _selectedImagePath = resolvedPath);
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                size: 52,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.momentsEmptyTitle, style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.momentsEmptyDescription,
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
