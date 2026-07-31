import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final GoRouterState state;
  const MainShell({super.key, required this.child, required this.state});

  @override
  Widget build(BuildContext context) {
    final location = state.uri.path;
    final index = switch (location) {
      '/' => 0,
      '/library' => 1,
      '/discover' => 2,
      '/profile' => 3,
      _ => 0,
    };

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedLibrary),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedDiscoverCircle),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedUser03),
            label: 'Profile',
          ),
        ],
        currentIndex: index,
        onTap: (index) => switch (index) {
          0 => context.go('/'),
          1 => context.go('/library'),
          2 => context.go('/discover'),
          3 => context.go('/profile'),
          _ => null,
        },
      ),
    );
  }
}
