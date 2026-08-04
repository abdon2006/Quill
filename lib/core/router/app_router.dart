import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/di/injection_container.dart';
import 'package:quill/core/router/main_shell.dart';
import 'package:quill/features/auth/presentation/screens/login_screen.dart';
import 'package:quill/features/auth/presentation/screens/signup_screen.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/screens/book_details_screen.dart';
import 'package:quill/features/home/presentation/screens/home_screen.dart';
import 'package:quill/features/onboarding/presentation/pages/onboarding_page.dart';

part 'app_routes.dart';

final GlobalKey<NavigatorState> _root = GlobalKey<NavigatorState>();
final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  debugLogDiagnostics: true,

  routes: [
    ShellRoute(
      navigatorKey: _root,
      routes: [
        /// Home
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.home,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<HomeBloc>()..add(FetchHomeBooksEvent()),
            child: HomeScreen(),
          ),
        ),

        /// Library
        GoRoute(
          path: AppRoutes.library,
          name: AppRoutes.library,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Library'))),
        ),

        /// Discover
        GoRoute(
          path: AppRoutes.discover,
          name: AppRoutes.discover,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Discover'))),
        ),

        /// Profile
        GoRoute(
          path: AppRoutes.profile,
          name: AppRoutes.profile,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Profile'))),
        ),
      ],

      builder: (context, state, child) => MainShell(state: state, child: child),
    ),

    /// Book Details
    GoRoute(
      path: AppRoutes.bookDeatails,
      name: AppRoutes.bookDeatails,
      builder: (context, state) => BookDetailsScreen(),
    ),

    /// OnBoarding
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => OnboardingPage(),
    ),

    /// Signup
    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signup,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignupScreen(), // شاشة الـ Signup المبدئية اللي هتعملها
          transitionDuration: const Duration(milliseconds: 1200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // 1. تأثير الذوبان (Fade)
            final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            );

            // 2. تأثير الزووم الخفيف لجوه (Scale)
            final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(scale: scaleAnimation, child: child),
            );
          },
        );
      },
    ),

    /// login
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => LoginScreen(),
    ),
  ],

  redirect: (context, state) => null,
);
