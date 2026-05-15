import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/core/services/firebase_service.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';
import 'package:familytrackapp/features/today/presentation/cubit/today_cubit.dart';
import 'package:familytrackapp/shared/widgets/loading_skeleton.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayCubit, TodayState>(
      builder: (context, state) {
        if (state is TodayLoading || state is TodayInitial) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: PageLoadingSkeleton(showHeroCard: true, itemCount: 4),
          );
        }
        if (state is TodayNoPersons) return const _NoPersonsView();
        if (state is TodayError) return _ErrorView(message: state.message);
        if (state is TodayLoaded) return _TodayLoadedView(state: state);
        return const SizedBox.shrink();
      },
    );
  }
}

class _TodayLoadedView extends StatelessWidget {
  const _TodayLoadedView({required this.state});
  final TodayLoaded state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 34),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<TodayCubit>().refresh(
              FirebaseService.currentUserId ?? '',
            ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _TodayHeader(
                state: state,
                onPersonTap: () => _showPersonPicker(context, state),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: _DaysCounterCard(person: state.selectedPerson),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text('Yaklasanlar', style: AppTextStyles.h2),
                    const Spacer(),
                    Text(
                      '+ EKLE',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _UpcomingDayItem(day: state.upcomingDays[i]),
                  childCount: state.upcomingDays.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl * 4)),
          ],
        ),
      ),
    );
  }

  void _showPersonPicker(BuildContext context, TodayLoaded state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TodayCubit>(),
        child: _PersonPickerSheet(
          persons: state.allPersons,
          selectedId: state.selectedPerson.id,
        ),
      ),
    );
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.state, required this.onPersonTap});
  final TodayLoaded state;
  final VoidCallback onPersonTap;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final person = state.selectedPerson;
    final initials = person.name.isNotEmpty
        ? person.name.trim().split(' ').map((w) => w[0]).take(2).join()
        : '?';

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        top + AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPersonTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials.toUpperCase(),
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bugun', style: AppTextStyles.h1),
              Text(
                person.relationshipType.label,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 30),
        ],
      ),
    );
  }
}

class _DaysCounterCard extends StatelessWidget {
  const _DaysCounterCard({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    final days = person.daysTogether;
    final monthNames = [
      '',
      'Ocak',
      'Subat',
      'Mart',
      'Nisan',
      'Mayis',
      'Haziran',
      'Temmuz',
      'Agustos',
      'Eylul',
      'Ekim',
      'Kasim',
      'Aralik',
    ];
    final start = '${person.startDate.day} ${monthNames[person.startDate.month]} ${person.startDate.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        children: [
          Text(
            'BIRLIKTE GECEN',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontSize: 28,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$days',
            style: AppTextStyles.counter.copyWith(fontSize: 84, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$start\'dan beri',
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              foregroundColor: AppColors.primary,
            ),
            icon: const Icon(Icons.share, size: 18),
            label: Text('Paylas', style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _UpcomingDayItem extends StatelessWidget {
  const _UpcomingDayItem({required this.day});
  final SpecialDay day;

  @override
  Widget build(BuildContext context) {
    final remaining = day.daysUntilNext;
    final monthNames = [
      '',
      'Ocak',
      'Subat',
      'Mart',
      'Nisan',
      'Mayis',
      'Haziran',
      'Temmuz',
      'Agustos',
      'Eylul',
      'Ekim',
      'Kasim',
      'Aralik',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day.title, style: AppTextStyles.h3.copyWith(fontSize: 40)),
                Text(
                  '${day.date.day} ${monthNames[day.date.month]}',
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$remaining',
                style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 56),
              ),
              Text(
                'KALDI',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonPickerSheet extends StatelessWidget {
  const _PersonPickerSheet({required this.persons, required this.selectedId});

  final List<Person> persons;
  final String selectedId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kisi Sec', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          ...persons.map((person) {
            final isSelected = person.id == selectedId;
            final initials = person.name.isNotEmpty
                ? person.name.trim().split(' ').map((w) => w[0]).take(2).join()
                : '?';
            return ListTile(
              onTap: () {
                context.read<TodayCubit>().selectPerson(
                      FirebaseService.currentUserId ?? '',
                      person,
                    );
                Navigator.pop(context);
              },
              leading: CircleAvatar(
                backgroundColor: isSelected ? AppColors.primary : AppColors.primaryLight,
                child: Text(initials.toUpperCase()),
              ),
              title: Text(person.name, style: AppTextStyles.bodyBold),
              subtitle: Text(person.relationshipType.label, style: AppTextStyles.caption),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
            );
          }),
        ],
      ),
    );
  }
}

class _NoPersonsView extends StatelessWidget {
  const _NoPersonsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_outline_rounded, size: 56, color: AppColors.primary),
              const SizedBox(height: AppSpacing.md),
              Text('Henuz kimse yok', style: AppTextStyles.h2),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 52, color: AppColors.primary),
              const SizedBox(height: AppSpacing.md),
              Text('Hata', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.sm),
              Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
