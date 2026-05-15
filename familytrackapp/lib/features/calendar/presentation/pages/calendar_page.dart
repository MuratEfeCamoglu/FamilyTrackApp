import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_strings.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/core/services/firebase_service.dart';
import 'package:familytrackapp/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';
import 'package:familytrackapp/shared/widgets/loading_skeleton.dart';

/// Takvim ana sayfası — aylık özel takvim + önemli günler listesi.
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.I<CalendarCubit>()
            ..loadCalendar(FirebaseService.currentUserId ?? ''),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          if (state is CalendarLoading || state is CalendarInitial) {
            return const PageLoadingSkeleton(showHeroCard: true, itemCount: 5);
          }
          if (state is CalendarError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<CalendarCubit>().loadCalendar(
                FirebaseService.currentUserId ?? '',
              ),
            );
          }
          if (state is CalendarLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _CalendarHeader()),
                SliverToBoxAdapter(child: _MonthCalendar(state: state)),
                // Seçili gün varsa o günün etkinlikleri, yoksa tümü
                _SpecialDaysList(state: state),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xl * 3),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────

class _CalendarHeader extends StatelessWidget {
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
              Text(AppStrings.navCalendar, style: AppTextStyles.h1),
            ],
          ),
          const Spacer(),
          // Bugüne dön
          GestureDetector(
            onTap: () => context.read<CalendarCubit>().goToToday(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppSpacing.sm + 4),
              ),
              child: Text(
                'Bugün',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Aylık Takvim
// ─────────────────────────────────────────────────────────

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({required this.state});
  final CalendarLoaded state;

  static const _trMonths = [
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
  static const _dayHeaders = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  Widget build(BuildContext context) {
    final month = state.displayedMonth;
    final year = month.year;
    final m = month.month;

    // Ayın ilk gününün haftanın hangi günü olduğu (Pazartesi = 0)
    final firstDay = DateTime(year, m, 1);
    final offset = (firstDay.weekday - 1) % 7; // Mon=0 … Sun=6
    final daysInMonth = DateTime(year, m + 1, 0).day;
    final totalCells = offset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    final eventDays = state.eventDaysForMonth(year, m);
    final today = DateTime.now();
    final isCurrentMonth = today.year == year && today.month == m;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Column(
        children: [
          // ── Ay / Yıl + Navigasyon ────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => context.read<CalendarCubit>().previousMonth(),
              ),
              Text('${_trMonths[m]} $year', style: AppTextStyles.h2),
              _NavButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => context.read<CalendarCubit>().nextMonth(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Gün adları ───────────────────────────────
          Row(
            children: _dayHeaders
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Gün hücreleri ────────────────────────────
          ...List.generate(rows, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (col) {
                  final cellIndex = row * 7 + col;
                  final day = cellIndex - offset + 1;
                  if (day < 1 || day > daysInMonth) {
                    return const Expanded(child: SizedBox());
                  }

                  final isToday = isCurrentMonth && today.day == day;
                  final cellDate = DateTime(year, m, day);
                  final isSelected =
                      state.selectedDate != null &&
                      state.selectedDate!.day == day &&
                      state.selectedDate!.month == m &&
                      state.selectedDate!.year == year;
                  final hasEvent = eventDays.contains(day);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          context.read<CalendarCubit>().selectDate(cellDate),
                      child: _DayCell(
                        day: day,
                        isToday: isToday,
                        isSelected: isSelected,
                        hasEvent: hasEvent,
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryDark, size: 20),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasEvent,
  });
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool hasEvent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : isToday
                ? AppColors.primaryLight
                : Colors.transparent,
            shape: BoxShape.circle,
            border: isToday && !isSelected
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          child: Center(
            child: Text(
              '$day',
              style: AppTextStyles.body.copyWith(
                fontWeight: isToday || isSelected
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? AppColors.primaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ),
        // Pembe etkinlik noktası
        AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: hasEvent ? 1.0 : 0.0,
          child: Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white70 : AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Özel Günler Listesi
// ─────────────────────────────────────────────────────────

class _SpecialDaysList extends StatelessWidget {
  const _SpecialDaysList({required this.state});
  final CalendarLoaded state;

  @override
  Widget build(BuildContext context) {
    final days = state.selectedDate != null
        ? state.eventsForDate(state.selectedDate)
        : state.upcomingSorted;

    final title = state.selectedDate != null
        ? '📅  ${state.selectedDate!.day.toString().padLeft(2, '0')}.${state.selectedDate!.month.toString().padLeft(2, '0')}.${state.selectedDate!.year} Etkinlikleri'
        : '📅  Önemli Günler';

    if (days.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Text(title, style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.lg),
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Bu günde etkinlik yok.',
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

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(title, style: AppTextStyles.h2),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 4,
          ),
          child: _SpecialDayItem(day: days[index - 1]),
        );
      }, childCount: days.length + 1),
    );
  }
}

class _SpecialDayItem extends StatelessWidget {
  const _SpecialDayItem({required this.day});
  final SpecialDay day;

  @override
  Widget build(BuildContext context) {
    final d = day.daysUntilNext;
    final isToday = d == 0;
    final isSoon = d <= 7 && !isToday;

    final dateFormatted =
        '${day.date.day.toString().padLeft(2, '0')}.${day.date.month.toString().padLeft(2, '0')}${day.isRecurring ? '' : '.${day.date.year}'}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          // İkon kutusu
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primary
                  : isSoon
                  ? AppColors.primaryDark
                  : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm + 2),
            ),
            child: Center(
              child: Text(day.type.emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Başlık + tip
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day.title, style: AppTextStyles.bodyBold),
                const SizedBox(height: 2),
                Text(
                  day.type.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Tarih + gün sayısı — sağda büyük pembe
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateFormatted,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.primary
                      : isSoon
                      ? AppColors.primaryDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSpacing.xs + 2),
                ),
                child: Text(
                  isToday ? 'Bugün!' : '$d gün',
                  style: AppTextStyles.caption.copyWith(
                    color: isToday || isSoon
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Hata Görünümü
// ─────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
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
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
