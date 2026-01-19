import 'package:animations/animations.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fitness_flutter/app/shell/tabs.dart';
import 'package:fitness_flutter/features/articles/data/sample_articles.dart';
import 'package:fitness_flutter/features/articles/pages/article_detail_page.dart';
import 'package:fitness_flutter/features/articles/pages/articles_page.dart';
import 'package:fitness_flutter/features/auth/pages/sign_in_page.dart';
import 'package:fitness_flutter/features/auth/pages/sign_up_page.dart';
import 'package:fitness_flutter/features/workouts/pages/daily_activity_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: _GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isAuthRoute = state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';

      if (user == null) {
        return isAuthRoute ? null : '/sign-in';
      }

      // Signed in (including anonymous/guest) -> keep them out of auth pages.
      if (isAuthRoute) return '/tabs';

      // Root goes to tabs.
      if (state.matchedLocation == '/') return '/tabs';

      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        pageBuilder: (context, state) => _fadeThroughPage(
          key: state.pageKey,
          child: const SignInPage(),
        ),
      ),
      GoRoute(
        path: '/sign-up',
        pageBuilder: (context, state) => _fadeThroughPage(
          key: state.pageKey,
          child: const SignUpPage(),
        ),
      ),
      GoRoute(
        path: '/tabs',
        pageBuilder: (context, state) => _fadeThroughPage(
          key: state.pageKey,
          child: const Tabs(),
        ),
      ),
      GoRoute(
        path: '/articles',
        pageBuilder: (context, state) => _fadeThroughPage(
          key: state.pageKey,
          child: const ArticlesPage(articles: kSampleArticles),
        ),
        routes: [
          GoRoute(
            path: ':index',
            pageBuilder: (context, state) {
              final raw = state.pathParameters['index'];
              final index = int.tryParse(raw ?? '');
              if (index == null || index < 0 || index >= kSampleArticles.length) {
                return _fadeThroughPage(
                  key: state.pageKey,
                  child: const ArticlesPage(articles: kSampleArticles),
                );
              }

              final article = kSampleArticles[index];
              return _fadeThroughPage(
                key: state.pageKey,
                child: ArticleDetailPage(article: article),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/daily-activity',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final args = extra is DailyActivityArgs
              ? extra
              : const DailyActivityArgs(
                  activeMinutes: 0,
                  calories: 0,
                  weeklyWorkouts: 0,
                  currentStreak: 0,
                  bestStreak: 0,
                );

          return _fadeThroughPage(
            key: state.pageKey,
            child: DailyActivityPage(args: args),
          );
        },
      ),
      GoRoute(
        path: '/',
        redirect: (_, __) => '/tabs',
      ),
    ],
  );
}

CustomTransitionPage<void> _fadeThroughPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
