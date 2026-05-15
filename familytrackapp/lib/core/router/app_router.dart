import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/services/firebase_service.dart';
import 'package:familytrackapp/features/auth/presentation/pages/login_page.dart';
import 'package:familytrackapp/features/calendar/presentation/pages/calendar_page.dart';
import 'package:familytrackapp/features/moments/presentation/pages/moments_page.dart';
import 'package:familytrackapp/features/profile/presentation/pages/profile_page.dart';
import 'package:familytrackapp/features/today/presentation/cubit/today_cubit.dart';
import 'package:familytrackapp/features/today/presentation/pages/today_page.dart';
import 'package:familytrackapp/shared/widgets/app_bottom_nav.dart';

/// Uygulama genelindeki route adlari.
class AppRouteNames {
  AppRouteNames._();

  static const String login = 'login';
  static const String today = 'today';
  static const String calendar = 'calendar';
  static const String moments = 'moments';
  static const String profile = 'profile';
}

/// Uygulama genelindeki route path'leri.
class AppRoutePaths {
  AppRoutePaths._();

  static const String login = '/login';
  static const String today = '/today';
  static const String calendar = '/calendar';
  static const String moments = '/moments';
  static const String profile = '/profile';
}

/// Alt sekmeli ana router tanimi.
class AppRouter {
  AppRouter._();

  /// `go_router` konfigurasyonunu olusturur.
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutePaths.login,
      redirect: (context, state) {
        final loggedIn = FirebaseService.isAuthenticated;
        final goingLogin = state.matchedLocation == AppRoutePaths.login;

        if (!loggedIn && !goingLogin) {
          return AppRoutePaths.login;
        }
        if (loggedIn && goingLogin) {
          return AppRoutePaths.today;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutePaths.login,
          name: AppRouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        StatefulShellRoute(
          builder: (context, state, navigationShell) {
            return _MainShell(navigationShell: navigationShell);
          },
          navigatorContainerBuilder: (context, navigationShell, children) {
            return _AnimatedBranchContainer(
              currentIndex: navigationShell.currentIndex,
              children: children,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutePaths.today,
                  name: AppRouteNames.today,
                  builder: (context, state) => const TodayPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutePaths.calendar,
                  name: AppRouteNames.calendar,
                  builder: (context, state) => const CalendarPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutePaths.moments,
                  name: AppRouteNames.moments,
                  builder: (context, state) => const MomentsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutePaths.profile,
                  name: AppRouteNames.profile,
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// 4 sekme arasinda gecisi yoneten ana iskelet.
class _MainShell extends StatelessWidget {
  const _MainShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.I<TodayCubit>()
            ..initialize(FirebaseService.currentUserId ?? ''),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: navigationShell,
        bottomNavigationBar: AppBottomNav(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}

/// Sayfalar arasi gecis animasyonlarini React Framer Motion stiliyle
/// (soft slide and fade) saglayan ozel kapsayici.
class _AnimatedBranchContainer extends StatefulWidget {
  const _AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<_AnimatedBranchContainer> createState() => _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<_AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _currentIndex;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..value = 1.0;
  }

  @override
  void didUpdateWidget(_AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _currentIndex = widget.currentIndex;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.children.length, (index) {
        final isActive = index == _currentIndex;
        final isPrevious = index == _previousIndex;

        return Offstage(
          offstage: !isActive && !isPrevious,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double opacity = 0.0;
              double dy = 0.0;

              if (isActive) {
                // initial={{ opacity: 0, y: 20 }} -> animate={{ opacity: 1, y: 0 }}
                opacity = _controller.value;
                dy = 20 * (1 - _controller.value);
              } else if (isPrevious) {
                // exit={{ opacity: 0, y: -20 }}
                opacity = 1 - _controller.value;
                dy = -20 * _controller.value;
              }

              return Transform.translate(
                offset: Offset(0, dy),
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: IgnorePointer(
                    ignoring: !isActive,
                    child: child,
                  ),
                ),
              );
            },
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}
