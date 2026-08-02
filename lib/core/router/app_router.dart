import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/main_shell.dart';
import 'package:quill/features/home/presentation/screens/book_details_screen.dart';
import 'package:quill/features/home/presentation/screens/home_screen.dart';

part 'app_routes.dart';

final GlobalKey<NavigatorState> _root = GlobalKey<NavigatorState>();
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,

  routes: [
    ShellRoute(
      navigatorKey: _root,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.home,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.library,
          name: AppRoutes.library,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Library'))),
        ),
        GoRoute(
          path: AppRoutes.discover,
          name: AppRoutes.discover,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Discover'))),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: AppRoutes.profile,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Profile'))),
        ),
      ],

      builder: (context, state, child) => MainShell(state: state, child: child),
    ),
    GoRoute(
      path: AppRoutes.bookDeatails,
      name: AppRoutes.bookDeatails,
      builder: (context, state) => BookDetailsScreen(),
    ),
  ],

  redirect: (context, state) => null,
);
