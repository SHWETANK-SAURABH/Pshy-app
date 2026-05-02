import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/sessions_controller.dart';
import '../widgets/session_tile.dart';
import '../widgets/loading_placeholders.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsState = ref.watch(sessionsControllerProvider);
    final controller = ref.read(sessionsControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'upcoming', label: Text('Upcoming')),
                        ButtonSegment(value: 'completed', label: Text('Completed')),
                      ],
                      selected: {sessionsState.filter},
                      onSelectionChanged: (selected) {
                        if (selected.isNotEmpty) {
                          controller.changeFilter(selected.first);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (sessionsState.isLoading && sessionsState.sessions.isEmpty)
                const LoadingPlaceholder()
              else if (sessionsState.error != null)
                Expanded(
                  child: Center(child: Text(sessionsState.error!)),
                )
              else if (sessionsState.sessions.isEmpty)
                const Expanded(child: Center(child: Text('No sessions available.')))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: sessionsState.sessions.length + (sessionsState.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == sessionsState.sessions.length) {
                        controller.loadSessions();
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final session = sessionsState.sessions[index];
                      return SessionTile(
                        session: session,
                        actionLabel: session.isUpcoming ? 'Complete' : 'No-show',
                        onAction: () {
                          if (session.isUpcoming) {
                            controller.markSessionCompleted(session.id);
                          } else {
                            controller.markSessionNoShow(session.id);
                          }
                        },
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(session.clientName, style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(height: 12),
                                    Text('Date & time: ${session.dateTime.toLocal()}'.split('.').first),
                                    const SizedBox(height: 8),
                                    Text('Meeting link:'),
                                    Text(session.meetingLink, style: const TextStyle(color: Colors.blue)),
                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.markSessionCompleted(session.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Mark completed'),
                                        ),
                                        const SizedBox(width: 12),
                                        OutlinedButton(
                                          onPressed: () {
                                            controller.markSessionNoShow(session.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No-show'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
