import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/widgets/custom_bottom__nav.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final GoRouterState state;
  const MainShell({super.key, required this.child, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      NavItem(icon: AppIcons.home, label: 'Home', path: AppRoutes.home),
      NavItem(
        icon: AppIcons.library,
        label: 'Library',
        path: AppRoutes.library,
      ),
      NavItem(
        icon: AppIcons.discover,
        label: 'Discover',
        path: AppRoutes.discover,
      ),
      NavItem(
        icon: AppIcons.profile,
        label: 'Profile',
        path: AppRoutes.profile,
      ),
    ];
    final location = state.uri.path;
    int index = switch (location) {
      '/' => 0,
      '/library' => 1,
      '/discover' => 2,
      '/profile' => 3,
      _ => 0,
    };

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: index,
        items: items,
        onTap: (newIndex) {
          if (index != newIndex) {
            context.go(items[newIndex].path);
          }
        },
      ),
    );
  }
}
