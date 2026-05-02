import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/availability_slot.dart';
import '../../domain/usecases/sync_availability_use_case.dart';
import '../../psychologist_portal_providers.dart';

class AvailabilityState {
  final bool isSaving;
  final bool isLoading;
  final DateTime selectedDate;
  final Map<DateTime, List<AvailabilitySlot>> slotsByDate;
  final List<DateTime> blockedDates;
  final String? message;

  AvailabilityState({
    required this.isSaving,
    required this.isLoading,
    required this.selectedDate,
    required this.slotsByDate,
    required this.blockedDates,
    this.message,
  });

  factory AvailabilityState.initial() {
    final now = DateTime.now();
    return AvailabilityState(
      isSaving: false,
      isLoading: false,
      selectedDate: DateTime(now.year, now.month, now.day),
      slotsByDate: {},
      blockedDates: [],
      message: null,
    );
  }

  AvailabilityState copyWith({
    bool? isSaving,
    bool? isLoading,
    DateTime? selectedDate,
    Map<DateTime, List<AvailabilitySlot>>? slotsByDate,
    List<DateTime>? blockedDates,
    String? message,
  }) {
    return AvailabilityState(
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
      selectedDate: selectedDate ?? this.selectedDate,
      slotsByDate: slotsByDate ?? this.slotsByDate,
      blockedDates: blockedDates ?? this.blockedDates,
      message: message,
    );
  }
}

class AvailabilityController extends StateNotifier<AvailabilityState> {
  AvailabilityController(Ref ref)
      : _syncAvailabilityUseCase = ref.read(syncAvailabilityUseCaseProvider),
        super(AvailabilityState.initial());

  final SyncAvailabilityUseCase _syncAvailabilityUseCase;
  final _uuid = const Uuid();

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void toggleBlockedDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final blocked = List<DateTime>.from(state.blockedDates);
    if (blocked.any((item) => item == normalized)) {
      blocked.removeWhere((item) => item == normalized);
    } else {
      blocked.add(normalized);
    }
    final updatedSlots = Map<DateTime, List<AvailabilitySlot>>.from(state.slotsByDate);
    updatedSlots.remove(normalized);
    state = state.copyWith(blockedDates: blocked, slotsByDate: updatedSlots);
  }

  void addSlot(DateTime start, DateTime end) {
    final dateKey = DateTime(state.selectedDate.year, state.selectedDate.month, state.selectedDate.day);
    final candidate = AvailabilitySlot(id: _uuid.v4(), start: start, end: end);
    final existing = state.slotsByDate[dateKey] ?? [];
    final overlap = existing.any((slot) => slot.overlaps(candidate));
    if (overlap) {
      state = state.copyWith(message: 'New slot overlaps an existing time range.');
      return;
    }

    final updated = [...existing, candidate]..sort((a, b) => a.start.compareTo(b.start));
    final updatedSlots = Map<DateTime, List<AvailabilitySlot>>.from(state.slotsByDate)
      ..[dateKey] = updated;
    state = state.copyWith(slotsByDate: updatedSlots, message: null);
  }

  void removeSlot(String slotId) {
    final dateKey = DateTime(state.selectedDate.year, state.selectedDate.month, state.selectedDate.day);
    final updatedSlots = Map<DateTime, List<AvailabilitySlot>>.from(state.slotsByDate);
    updatedSlots[dateKey] = updatedSlots[dateKey]?.where((slot) => slot.id != slotId).toList() ?? [];
    if (updatedSlots[dateKey]?.isEmpty ?? false) {
      updatedSlots.remove(dateKey);
    }
    state = state.copyWith(slotsByDate: updatedSlots);
  }

  List<AvailabilitySlot> get selectedDateSlots {
    final dateKey = DateTime(state.selectedDate.year, state.selectedDate.month, state.selectedDate.day);
    return state.slotsByDate[dateKey] ?? [];
  }

  Future<void> saveAvailability() async {
    state = state.copyWith(isSaving: true, message: null);
    try {
      final allSlots = state.slotsByDate.values.expand((element) => element).toList();
      await _syncAvailabilityUseCase.execute(
        slots: allSlots,
        blockedDates: state.blockedDates,
      );
      state = state.copyWith(isSaving: false, message: 'Availability synced successfully.');
    } catch (error) {
      state = state.copyWith(isSaving: false, message: error.toString());
    }
  }
}

final availabilityControllerProvider = StateNotifierProvider<AvailabilityController, AvailabilityState>(
  (ref) => AvailabilityController(ref),
);
