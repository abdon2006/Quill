import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/di/injection_container.dart';
import 'package:quill/core/router/main_shell.dart';
import 'package:quill/features/auth/presentation/screens/auth_choose_screen.dart';
import 'package:quill/features/auth/presentation/screens/login/login_screen.dart';
import 'package:quill/features/auth/presentation/screens/signup/signup_screen.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/screens/book_details_screen.dart';
import 'package:quill/features/home/presentation/screens/home_screen.dart';
import 'package:quill/features/onboarding/presentation/pages/onboarding_page.dart';

part 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  debugLogDiagnostics: true,

  routes: [
    ShellRoute(
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
      builder: (context, state) => SignupScreen(),
    ),

    /// login
    GoRoute(
      path: AppRoutes.choose,
      name: AppRoutes.choose,
      builder: (context, state) => AuthChooseScreen(),
    ),

    /// Signup
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => LoginScreen(),
    ),
  ],

  redirect: (context, state) => null,
);
