import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
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
    final upcomingDays = state.upcomingDays;
    final todaysEvents = upcomingDays.where((d) => d.daysUntilNext == 0).toList();
    final futureEvents = upcomingDays.where((d) => d.daysUntilNext > 0).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<TodayCubit>().refresh(
          FirebaseService.currentUserId ?? '',
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _TodayHeader(state: state)),
            if (todaysEvents.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: _TodaysEventCard(event: todaysEvents.first),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.sm,
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
                    Text('Yaklaşanlar', style: AppTextStyles.h2),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        '+ EKLE',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (futureEvents.isEmpty)
              const SliverToBoxAdapter(child: _EmptyUpcomingView())
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _UpcomingDayItem(day: futureEvents[i]),
                    childCount: futureEvents.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.state});
  final TodayLoaded state;

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
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
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
          const SizedBox(width: AppSpacing.sm),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bugün', style: AppTextStyles.h1.copyWith(fontSize: 26)),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ),
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
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    final start =
        '${person.startDate.day} ${monthNames[person.startDate.month]} ${person.startDate.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: AppDecorations.elevatedShadow,
      ),
      child: Column(
        children: [
          Text(
            'BİRLİKTE GEÇEN',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13,
              letterSpacing: 2.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$days',
            style: AppTextStyles.counter.copyWith(
              fontSize: 80,
              color: AppColors.primary,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$start\'dan beri',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            icon: const Icon(Icons.share, size: 18),
            label: Text(
              'Paylaş',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primary,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaysEventCard extends StatelessWidget {
  const _TodaysEventCard({required this.event});
  final SpecialDay event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primaryLight, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000), // very soft neutral shadow
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Text(
              event.type.emoji,
              style: const TextStyle(fontSize: 48),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'BUGÜN!',
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary,
              fontSize: 14,
              letterSpacing: 2.4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.title,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textPrimary,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            event.type.label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
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
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
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
                Text(
                  day.title,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${day.date.day} ${monthNames[day.date.month]}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$remaining',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.primary,
                  fontSize: 38,
                ),
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
              const Icon(
                Icons.people_outline_rounded,
                size: 56,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Henüz kimse yok', style: AppTextStyles.h2),
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
              const Icon(
                Icons.error_outline_rounded,
                size: 52,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Hata', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyUpcomingView extends StatelessWidget {
  const _EmptyUpcomingView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 22,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          'Henüz yaklaşan gün yok.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
