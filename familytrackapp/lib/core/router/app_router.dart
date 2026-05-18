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

/// Sayfalar arasi gecisi yuksek performansli, anlik ve 60/120 FPS hizinda
/// saglayan, durumlari koruyan (state preservation) yerel kapsayici.
class _AnimatedBranchContainer extends StatelessWidget {
  const _AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: children,
    );
  }
}
