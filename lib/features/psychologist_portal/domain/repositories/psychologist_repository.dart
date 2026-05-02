import '../entities/availability_slot.dart';
import '../entities/dashboard_stats.dart';
import '../entities/psychologist_user.dart';
import '../entities/session_page.dart';

abstract class PsychologistRepository {
  Future<PsychologistUser> login({required String email, required String password});
  Future<void> forgotPassword({required String email});
  Future<void> logout();
  Future<PsychologistUser?> restoreSession();
  Future<DashboardStats> getDashboard();
  Future<SessionPage> getSessions({required String status, required int page, required int pageSize});
  Future<void> saveAvailability({
    required List<AvailabilitySlot> slots,
    required List<DateTime> blockedDates,
  });
  Future<PsychologistUser> updateProfile({required PsychologistUser user});
}
