import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/dashboard_stats.dart';
import '../../domain/usecases/get_dashboard_use_case.dart';
import '../../psychologist_portal_providers.dart';

class DashboardController extends StateNotifier<AsyncValue<DashboardStats>> {
  DashboardController(Ref ref)
      : _dashboardUseCase = ref.read(getDashboardUseCaseProvider),
        super(const AsyncValue.loading()) {
    loadDashboard();
  }

  final GetDashboardUseCase _dashboardUseCase;

  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _dashboardUseCase.execute());
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}

final dashboardControllerProvider = StateNotifierProvider<DashboardController, AsyncValue<DashboardStats>>(
  (ref) => DashboardController(ref),
);
