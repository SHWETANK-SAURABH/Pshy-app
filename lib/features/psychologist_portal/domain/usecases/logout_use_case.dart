import '../repositories/psychologist_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this._repository);

  final PsychologistRepository _repository;

  Future<void> execute() {
    return _repository.logout();
  }
}
