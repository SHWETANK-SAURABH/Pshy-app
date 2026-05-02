import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PsychologistPortalShell extends ConsumerWidget {
  const PsychologistPortalShell({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      '/psychologist/dashboard',
      '/psychologist/availability',
      '/psychologist/sessions',
      '/psychologist/profile',
    ];

    final currentIndex = items.indexWhere(location.startsWith);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (index) {
          context.go(items[index]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Availability'),
          NavigationDestination(icon: Icon(Icons.event_note), label: 'Sessions'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
