import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/section_card.dart';
import '../widgets/loading_placeholders.dart';

class PsychologistDashboardScreen extends ConsumerWidget {
  const PsychologistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.read(dashboardControllerProvider.notifier).refresh(),
        ),
      ]),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
        child: dashboardState.when(
          data: (data) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Hello, welcome back', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SectionCard(
                        title: 'Upcoming',
                        value: '${data.upcomingSessions}',
                        icon: Icons.schedule,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SectionCard(
                        title: 'Completed',
                        value: '${data.completedSessions}',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SectionCard(
                        title: 'Total sessions',
                        value: '${data.totalSessions}',
                        icon: Icons.bar_chart,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Upcoming sessions', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                if (data.upcomingSchedule.isEmpty)
                  const Text('No upcoming sessions yet.')
                else
                  ...data.upcomingSchedule.map(
                    (session) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(session.clientName),
                        subtitle: Text('${session.dateTime.toLocal()}'.split('.').first),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text('Completed sessions', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                if (data.completedSchedule.isEmpty)
                  const Text('No completed sessions yet.')
                else
                  ...data.completedSchedule.take(3).map(
                        (session) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            title: Text(session.clientName),
                            subtitle: Text('${session.dateTime.toLocal()}'.split('.').first),
                            trailing: const Icon(Icons.check, color: Colors.green),
                          ),
                        ),
                      ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(20),
            child: DashboardSkeleton(),
          ),
          error: (error, stack) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Unable to load dashboard', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
