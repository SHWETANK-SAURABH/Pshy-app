import '../entities/availability_slot.dart';
import '../repositories/psychologist_repository.dart';

class SyncAvailabilityUseCase {
  SyncAvailabilityUseCase(this._repository);

  final PsychologistRepository _repository;

  Future<void> execute({
    required List<AvailabilitySlot> slots,
    required List<DateTime> blockedDates,
  }) {
    return _repository.saveAvailability(slots: slots, blockedDates: blockedDates);
  }
}
