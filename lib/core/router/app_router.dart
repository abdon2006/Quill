import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Home'))),
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

  redirect: (context, state) => null,
);
