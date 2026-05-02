import '../entities/dashboard_stats.dart';
import '../repositories/psychologist_repository.dart';

class GetDashboardUseCase {
  GetDashboardUseCase(this._repository);

  final PsychologistRepository _repository;

  Future<DashboardStats> execute() {
    return _repository.getDashboard();
  }
}
