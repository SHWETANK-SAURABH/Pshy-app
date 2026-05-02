import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/availability_controller.dart';

class AvailabilityManagementScreen extends ConsumerWidget {
  const AvailabilityManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(availabilityControllerProvider);
    final controller = ref.read(availabilityControllerProvider.notifier);
    final today = DateTime.now();
    final days = List.generate(
      14,
      (index) => DateTime(today.year, today.month, today.day).add(Duration(days: index)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Availability')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isSelected = day == state.selectedDate;
                  final isBlocked = state.blockedDates.any((item) => item == day);
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text('${day.month}/${day.day}'),
                      selected: isSelected,
                      onSelected: (_) => controller.selectDate(day),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                      ),
                      avatar: isBlocked ? const Icon(Icons.block, size: 18) : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => controller.toggleBlockedDate(state.selectedDate),
                    child: Text(state.blockedDates.any((item) => item == state.selectedDate) ? 'Unblock date' : 'Block date'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Time slots for selected day', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            if (state.blockedDates.any((item) => item == state.selectedDate))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text('This date is blocked. Unblock to add or keep slots.'),
              )
            else
              Column(
                children: [
                  for (final slot in controller.selectedDateSlots)
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        title: Text('${slot.start.hour.toString().padLeft(2, '0')}:${slot.start.minute.toString().padLeft(2, '0')} - ${slot.end.hour.toString().padLeft(2, '0')}:${slot.end.minute.toString().padLeft(2, '0')}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => controller.removeSlot(slot.id),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () async {
                      final start = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                      if (!context.mounted || start == null) return;
                      final end = await showTimePicker(context: context, initialTime: TimeOfDay(hour: start.hour + 1, minute: start.minute));
                      if (!context.mounted || end == null) return;
                      final selectedStart = DateTime(state.selectedDate.year, state.selectedDate.month, state.selectedDate.day, start.hour, start.minute);
                      final selectedEnd = DateTime(state.selectedDate.year, state.selectedDate.month, state.selectedDate.day, end.hour, end.minute);
                      if (!selectedEnd.isAfter(selectedStart)) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The end time must be after the start time.')));
                        return;
                      }
                      controller.addSlot(selectedStart, selectedEnd);
                    },
                    child: const Text('Add time slot'),
                  ),
                ],
              ),
            const Spacer(),
            if (state.message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(state.message!, style: TextStyle(color: state.message!.contains('success') ? Colors.green : Colors.red)),
              ),
            FilledButton(
              onPressed: state.isSaving ? null : () => controller.saveAvailability(),
              child: state.isSaving ? const CircularProgressIndicator() : const Text('Sync availability'),
            ),
          ],
        ),
      ),
    );
  }
}
