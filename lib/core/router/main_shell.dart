import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
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
